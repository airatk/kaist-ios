//
//  ScheduleScreen.swift
//  kaist
//
//  Created by Airat K on 28/6/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class StudentScheduleScreen: UITableViewController {
    
    private var schedule: [String: [[String: String]]]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = {
            let segmentedControl = UISegmentedControl(items: [ "чётная", "нечётная" ])
            
            segmentedControl.selectedSegmentIndex = CurrentDay.isWeekEven ? 0 : 1
            
            return segmentedControl
        }()
        
        self.tableView = {
            let tableView = UITableView(frame: .zero, style: .grouped)
            
            tableView.backgroundColor = .white
            tableView.backgroundView = EmptyScreenView(emoji: "🙅🏼‍♀️", message: "Расписания нет")
            
            tableView.tableHeaderView = {
                let tableHeaderView = UILabel()
                
                tableHeaderView.text = "текущая неделя " + (CurrentDay.isWeekEven ? "чётная" : "нечётная")
                tableHeaderView.font = .systemFont(ofSize: 13)
                tableHeaderView.textColor = .gray
                tableHeaderView.textAlignment = .center
                
                tableHeaderView.frame = self.navigationController!.navigationBar.frame
                
                return tableHeaderView
            }()
            
            tableView.separatorStyle = .none
            tableView.register(StudentSubjectCell.self, forCellReuseIdentifier: StudentSubjectCell.ID)
            
            tableView.showsVerticalScrollIndicator = false
            
            return tableView
        }()
        
        self.createStudent()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tableView.frame = UIScreen.main.bounds
    }
    
    
    #warning("Gotta be done on refresh instead")
    private func createStudent() {
        let student = Student()
        
        student.groupScheduleID = "17896"
        //student.group = "4333"
        //student.group = "4101"
        
        student.getSchedule(ofType: .classes) { (schedule, error)  in
            guard error == nil, let schedule = schedule else { return }
            
            self.schedule = schedule
        }
    }
    
}

extension StudentScheduleScreen {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let schedule = self.schedule {
            self.tableView.backgroundView?.isHidden = true
            
            return schedule.count
        } else {
            self.tableView.backgroundView?.isHidden = false
            
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let schedule = self.schedule, let subjectsOnDayOfSection = schedule["\(section + 1)"] else { return 0 }
        
        return subjectsOnDayOfSection.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let schedule = self.schedule else { return "День недели, Дата" }
        
        let weekdays = [
            "1": "Понедельник",
            "2": "Вторник",
            "3": "Среда",
            "4": "Четверг",
            "5": "Пятница",
            "6": "Суббота"
        ]
        let weekdayIndex = schedule.keys.sorted()[section]
        let weekday = weekdays[weekdayIndex]!
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2  // Monday is the 1st weekday now
        
        let currentWeekday = calendar.component(.weekday, from: Date())
        let askedDayWeekday = Int(weekdayIndex)!
        
        #warning("Calculations are wrong at the beginning & end of a month")
        let day = CurrentDay.date.0 + (askedDayWeekday - currentWeekday)
        let month = CurrentDay.date.1
        
        return "\(weekday), \(day) \(month)"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subjectCell = tableView.dequeueReusableCell(withIdentifier: StudentSubjectCell.ID, for: indexPath) as! StudentSubjectCell
        
        guard let schedule = self.schedule, let subjectsOfDay = schedule["\(indexPath.section + 1)"] else { return subjectCell }
        
        subjectCell.title.text = subjectsOfDay[indexPath.row]["disciplName"]
        subjectCell.type.text = subjectsOfDay[indexPath.row]["disciplType"]
        
        #warning("Should not show some data")
        if let lecturerName = subjectsOfDay[indexPath.row]["prepodName"], !lecturerName.isEmpty {
            subjectCell.lecturerName.text = lecturerName
        } else {
//            subjectCell.lecturerName.removeFromSuperview()
//            subjectCell.lecturerNameTextIcon.removeFromSuperview()
        }
        
        if let department = subjectsOfDay[indexPath.row]["orgUnitName"], !department.isEmpty {
            subjectCell.department.text = department
        } else {
//            subjectCell.department.removeFromSuperview()
//            subjectCell.departmentTextIcon.removeFromSuperview()
        }
        
        subjectCell.time.text = subjectsOfDay[indexPath.row]["dayTime"]
        
        let auditorium = subjectsOfDay[indexPath.row]["audNum"]!
        let building = subjectsOfDay[indexPath.row]["buildNum"]!
        subjectCell.place.text = building + (!auditorium.isEmpty ? ", " + auditorium : "")
        
        if let weekType = subjectsOfDay[indexPath.row]["dayDate"], !weekType.isEmpty {
            subjectCell.weekType.text = weekType
        } else {
            //subjectCell.weekType.removeFromSuperview()
        }
        
        return subjectCell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

extension StudentScheduleScreen {
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        guard self.schedule != nil else { return }
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        guard let tabBar = self.tabBarController?.tabBar else { return }
        
        let isHidden = scrollView.panGestureRecognizer.translation(in: scrollView).y < 0
        
        guard navigationBar.isHidden != isHidden else { return }
        
        let topBarHeight = UIApplication.shared.statusBarFrame.height + navigationBar.frame.height
        
        navigationBar.isHidden = false
        tabBar.isHidden = false
        
        UIView.animate(withDuration: 0.275, animations: {
            navigationBar.frame = navigationBar.frame.offsetBy(dx: 0, dy: isHidden ? -topBarHeight : topBarHeight)
            tabBar.frame = tabBar.frame.offsetBy(dx: 0, dy: isHidden ? tabBar.frame.height : -tabBar.frame.height)
        }, completion: { _ in
            navigationBar.isHidden = isHidden
            tabBar.isHidden = isHidden
        })
    }
    
}
