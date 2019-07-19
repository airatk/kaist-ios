//
//  ScheduleScreen.swift
//  kaist
//
//  Created by Airat K on 28/6/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class ScheduleScreen: UITableViewController {
    
    private var schedule: [String: [[String: String]]]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.setUpNavigationBar()
        self.setUpTableView()
        
        self.createStudent()
    }
    
    
    private func setUpNavigationBar() {
        let segmentedControl = UISegmentedControl(items: [ "чётная", "нечётная" ])
        
        segmentedControl.selectedSegmentIndex = CurrentDay.isWeekEven ? 0 : 1
        
        self.navigationItem.titleView = segmentedControl
    }
    
    private func setUpTableView() {
        let width = self.view.frame.width
        let height = self.view.frame.height - self.tabBarController!.tabBar.frame.height
        
        self.tableView = UITableView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: height)), style: .grouped)
        
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .white
        self.tableView.backgroundView = EmptyScheduleScreen()
        
        self.tableView.register(SubjectCell.self, forCellReuseIdentifier: SubjectCell.subjectCellID)
        
        self.view.layoutIfNeeded()
    }
    
    
    private func createStudent() {
        let student = Student()
        
        student.group = "4333"
        
        student.getSchedule(ofType: .classes) { (schedule, error)  in
            guard error == nil, let schedule = schedule else { return }
            
            self.schedule = schedule
        }
    }

}

extension ScheduleScreen {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let schedule = self.schedule else {
            self.tableView.backgroundView?.isHidden = false
            
            return 0
        }
        
        self.tableView.backgroundView?.isHidden = true
        
        return schedule.count
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
        
        // Sunday is the 1st weekday by default, so decremented
        let currentWeekday = Calendar(identifier: .gregorian).component(.weekday, from: Date()) - 1
        let askedDayWeekday = Int(weekdayIndex)!
        
        let day = CurrentDay.date.0 + (askedDayWeekday - currentWeekday)
        let month = CurrentDay.date.1
        
        return "\(weekday), \(day) \(month)"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subjectCell = self.tableView.dequeueReusableCell(withIdentifier: SubjectCell.subjectCellID, for: indexPath) as! SubjectCell
        
        let day = "\(indexPath.section + 1)"
        guard let schedule = self.schedule, let subjectsOfDay = schedule[day] else { return subjectCell }
        
        subjectCell.title.text = subjectsOfDay[indexPath.row]["disciplName"]
        subjectCell.type.text = subjectsOfDay[indexPath.row]["disciplType"]
        subjectCell.lecturerName.text = subjectsOfDay[indexPath.row]["prepodName"]
        subjectCell.department.text = subjectsOfDay[indexPath.row]["orgUnitName"]
        subjectCell.time.text = subjectsOfDay[indexPath.row]["dayTime"]
        subjectCell.place.text = subjectsOfDay[indexPath.row]["buildNum"]! + ", " + subjectsOfDay[indexPath.row]["audNum"]!
        
        //subjectCell.weekType.text = subjectsOfDay[indexPath.row]["dayDate"]
        
        return subjectCell
    }
    
}
