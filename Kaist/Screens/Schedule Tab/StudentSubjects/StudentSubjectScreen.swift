//
//  StudentSubjectsScreen.swift
//  kaist
//
//  Created by Airat K on 28/6/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class StudentSubjectsScreen: AUIExpandableTableViewController {
    
    private var isNextWeekSelected: Bool = false
    
    private var initialSchedule: Student.Schedule?
    private var schedule: Student.Schedule?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = {
            let weektypeChooser = UISegmentedControl(items: [
                "текущая, \(CurrentDay.isWeekEven ? "чётная" : "нечётная")",
                "следующая"
            ])
            
            weektypeChooser.apportionsSegmentWidthsByContent = true
            weektypeChooser.selectedSegmentIndex = 0
            
            weektypeChooser.addTarget(self, action: #selector(self.selectWeektype), for: .valueChanged)
            
            return weektypeChooser
        }()
        
        self.refreshControl?.addTarget(self, action: #selector(self.refreshSchedule), for: .valueChanged)
        self.tableView.register(StudentSubjectCell.self, forCellReuseIdentifier: StudentSubjectCell.reuseID)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.refreshControl?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.refreshControl!.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
            self.refreshControl!.topAnchor.constraint(equalTo: self.tableView.safeAreaLayoutGuide.topAnchor, constant: 30)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard AppDelegate.shared.student.isSetUp else {
            self.present({
                let welcomeScreen = UINavigationController(rootViewController: WelcomeScreen())
            
                welcomeScreen.navigationBar.setBackgroundImage(UIImage(), for: .default)
                welcomeScreen.navigationBar.shadowImage = UIImage()
                
                return welcomeScreen
            }(), animated: true)
            
            self.initialSchedule = nil
            self.schedule = nil
            self.tableView.reloadData()
            
            return
        }
        
        self.tabBarController?.tabBar.items?[1].isEnabled = AppDelegate.shared.student.isFull
        
        if self.initialSchedule == nil {
            self.tableView.setContentOffset(CGPoint(x: 0, y: -100), animated: true)
            self.refreshControl?.beginRefreshing()
            self.refreshSchedule()
        }
    }
    
    
    private func setScheduleUsingInitialSchedule() {
        self.schedule = self.initialSchedule
        
        guard self.schedule != nil else { return }  // Still need to change self.schedule itself, so no `let` is allowed
        
        let oppositeWeektypeTrait = (self.isNextWeekSelected ? CurrentDay.isWeekEven : !CurrentDay.isWeekEven) ? "чет" : "неч"
        var indexOfSubject = 0
        
        for (numberOfDay, subjects) in self.schedule! {
            for subject in subjects {
                if subject["dayDate"] == oppositeWeektypeTrait {
                    self.schedule![numberOfDay]!.remove(at: indexOfSubject)
                    indexOfSubject -= 1
                }
                
                indexOfSubject += 1
            }
            
            if self.schedule![numberOfDay]!.isEmpty {
                self.schedule![numberOfDay] = [ ["disciplName": "Выходной"] ]
            }
            
            indexOfSubject = 0
        }
    }
    
    
    @objc private func selectWeektype(_ sender: UISegmentedControl) {
        self.isNextWeekSelected = sender.selectedSegmentIndex == 1
        self.setScheduleUsingInitialSchedule()
        self.tableView.reloadData()
    }
    
    @objc private func refreshSchedule() {
        AppDelegate.shared.student.getSchedule(ofType: .classes) { (schedule, error) in
            if let error = error {
                self.tableView.backgroundView = AUIEmptyScreenView(message: error.rawValue)
            }
            
            self.initialSchedule = schedule
            self.setScheduleUsingInitialSchedule()
            
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
}

extension StudentSubjectsScreen {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        tableView.backgroundView?.isHidden = self.schedule != nil
        
        return self.schedule?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schedule!["\(section + 1)"]!.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let weekdays = [
            "1": "Понедельник",
            "2": "Вторник",
            "3": "Среда",
            "4": "Четверг",
            "5": "Пятница",
            "6": "Суббота"
        ]
        
        let askedDayWeekday = self.schedule!.keys.sorted()[section]
        let date = CurrentDay.date(shiftedToDays: Int(askedDayWeekday)! - CurrentDay.weekday + (self.isNextWeekSelected ? 7 : 0))
        
        return "\(weekdays[askedDayWeekday]!), \(date.day) \(date.month)"
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let weekday = view as? UITableViewHeaderFooterView else { return }
        
        weekday.textLabel?.textColor = ((section + 1) == CurrentDay.weekday && !self.isNextWeekSelected) ? .lightBlue : .darkGray
        weekday.textLabel?.textColor = weekday.textLabel?.textColor.withAlphaComponent(0.8)
        weekday.textLabel?.font = .boldSystemFont(ofSize: 12)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subjectCell = tableView.dequeueReusableCell(withIdentifier: StudentSubjectCell.reuseID, for: indexPath) as! StudentSubjectCell
        
        let subject = self.schedule!["\(indexPath.section + 1)"]![indexPath.row]
        
        subjectCell.title.text = subject["disciplName"]
        guard subjectCell.title.text != "Выходной" else {
            subjectCell.hide(.allButTitle)
            return subjectCell
        }
        
        subjectCell.type.text = subject["disciplType"]
        
        if subject["prepodName"]!.isEmpty {
            subjectCell.hide(.lecturer)
        } else {
            subjectCell.lecturer.text = subject["prepodName"]
        }
        subjectCell.department.text = subject["orgUnitName"]
        
        subjectCell.time.text = subject["dayTime"]
        subjectCell.place.text = subject["audNum"]!.isEmpty ? subject["buildNum"]! : "\(subject["buildNum"]!), \(subject["audNum"]!)"
        
        let dates = (subject["dayDate"] == "чет" || subject["dayDate"] == "неч") ? "" : subject["dayDate"]!
        if dates.isEmpty {
            subjectCell.hide(.dates)
        } else {
            subjectCell.dates.text = dates
        }
        
        return subjectCell
    }
    
}
