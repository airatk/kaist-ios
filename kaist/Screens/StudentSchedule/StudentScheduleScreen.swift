//
//  ScheduleScreen.swift
//  kaist
//
//  Created by Airat K on 28/6/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class StudentScheduleScreen: UITableViewController {
    
    private var initialSchedule: [String: [[String: String]]]?
    private var schedule: [String: [[String: String]]]?
    
    private var isNextWeekSelected: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = {
            let tableView = UITableView(frame: .zero, style: .grouped)
            
            tableView.backgroundColor = .white
            tableView.backgroundView = EmptyScreenView(emoji: "✈️", emojiSize: 50, isEmojiCentered: true)
            
            tableView.showsVerticalScrollIndicator = false
            tableView.separatorStyle = .none
            
            tableView.register(StudentSubjectCell.self, forCellReuseIdentifier: StudentSubjectCell.ID)
            
            return tableView
        }()
        
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
        
        self.refreshControl = {
            let refreshControl = UIRefreshControl()
            
            refreshControl.addTarget(self, action: #selector(self.refreshSchedule), for: .valueChanged)
            
            return refreshControl
        }()
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
            let loginNavigationController = UINavigationController(rootViewController: WelcomeScreen())
            
            loginNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            loginNavigationController.navigationBar.shadowImage = UIImage()
            
            self.present(loginNavigationController, animated: true)
            
            self.initialSchedule = nil
            
            return
        }
        
        if self.initialSchedule == nil {
            self.refreshControl?.beginRefreshing()
            self.tableView.setContentOffset(CGPoint(x: 0, y: -100), animated: true)
            self.refreshSchedule()
        }
    }
    
    
    private func setScheduleUsingInitialSchedule() {
        guard self.initialSchedule != nil else { return }
        
        self.schedule = self.initialSchedule
        
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
            indexOfSubject = 0
            
            if self.schedule![numberOfDay]!.isEmpty {
                self.schedule![numberOfDay] = [ ["disciplName": "Выходной"] ]
            }
        }
    }
    
    
    @objc private func refreshSchedule() {
        AppDelegate.shared.student.getSchedule(ofType: .classes) { (schedule, error) in
            if let error = error {
                self.tableView.backgroundView = EmptyScreenView(emoji: "🤷🏼‍♀️", message: error.rawValue)
            } else {
                self.initialSchedule = schedule
                self.setScheduleUsingInitialSchedule()
            }
            
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func selectWeektype(_ sender: UISegmentedControl) {
        self.isNextWeekSelected = sender.selectedSegmentIndex == 1
        
        self.setScheduleUsingInitialSchedule()
        self.tableView.reloadData()
    }
    
}

extension StudentScheduleScreen {
    
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
        let weekdayKey = self.schedule!.keys.sorted()[section]
        let weekday = weekdays[weekdayKey]!
        
        let currentWeekday = CurrentDay.weekday
        let askedDayWeekday = Int(weekdayKey)!
        
        let date = CurrentDay.date(shiftedToDays: askedDayWeekday - currentWeekday + (self.isNextWeekSelected ? 7 : 0))
        
        return "\(weekday), \(date.day) \(date.month)"
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        
        if (section + 1) == CurrentDay.weekday && !self.isNextWeekSelected {
            headerView.textLabel?.textColor = .lightBlue
        }
        
        headerView.textLabel?.font = .boldSystemFont(ofSize: 12)
        headerView.textLabel?.textColor = headerView.textLabel?.textColor.withAlphaComponent(0.8)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subjectCell = tableView.dequeueReusableCell(withIdentifier: StudentSubjectCell.ID, for: indexPath) as! StudentSubjectCell
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension StudentScheduleScreen {
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard self.schedule != nil else { return }

        self.changeBarsVisibility(isHidden: scrollView.panGestureRecognizer.translation(in: scrollView).y <= 0)
    }

    override func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        self.changeBarsVisibility(isHidden: false)

        return true
    }


    private func changeBarsVisibility(isHidden: Bool) {
        guard self.navigationController?.navigationBar.isHidden != isHidden else { return }

        guard let navBar = self.navigationController?.navigationBar else { return }
        guard let tabBar = self.tabBarController?.tabBar else { return }

        navBar.isHidden = false
        tabBar.isHidden = false

        UIView.animate(withDuration: 0.25, animations: {
            (UIApplication.shared.value(forKey: "statusBar") as! UIView).backgroundColor = isHidden ? .white : .clear
            
            navBar.frame = navBar.frame.offsetBy(dx: 0, dy: isHidden ? -navBar.frame.height : navBar.frame.height)
            tabBar.frame = tabBar.frame.offsetBy(dx: 0, dy: isHidden ? tabBar.frame.height : -tabBar.frame.height)
        }, completion: { _ in
            navBar.isHidden = isHidden
            tabBar.isHidden = isHidden
        })
    }
    
}
