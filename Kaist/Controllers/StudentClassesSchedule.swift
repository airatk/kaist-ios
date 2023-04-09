//
//  StudentClassesSchedule.swift
//  Kaist
//
//  Created by Airat K on 28/6/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class StudentClassesScheduleController: ExpandableTableViewController {

    private let currentWeekdayIndex: Int = CalendarService.getWeekdayIndex()

    private var schedule: ClassesSchedule<StudentClass>?


    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Занятия"

        self.refreshControl?.addTarget(self, action: #selector(self.refreshSchedule), for: .valueChanged)

        self.tableView.register(StudentClassCell.self, forCellReuseIdentifier: StudentClassCell.reuseId)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(self.resetAndRefreshSchedule), name: .refreshSchedule, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: .refreshSchedule, object: nil)
    }

}

extension StudentClassesScheduleController {

    @objc
    private func resetAndRefreshSchedule() {
        self.resetSchedule()
        self.refreshSchedule()
    }

    @objc
    private func refreshSchedule() {
        self.refreshControl?.beginRefreshing()

        StudentApiService.client.getSchedule(ofType: .classes) { (schedule, error) in
            if let error = error {
                self.tableView.backgroundView = EmptyView(message: error.localizedDescription)
            }

            self.schedule = schedule

            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }

    private func resetSchedule() {
        self.schedule = nil
        self.tableView.reloadData()
    }

}

extension StudentClassesScheduleController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        tableView.backgroundView?.isHidden = self.schedule != nil

        guard let schedule = self.schedule, !schedule.isEmpty else { return 0 }

        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfClassesInDay: Int = self.schedule![section]!.count
        
        guard numberOfClassesInDay > 0 else { return 1 }

        return numberOfClassesInDay
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date: DateData = CalendarService.getDate(shiftedRaltiveToTodayByDays: section - self.currentWeekdayIndex)
        let sectionTitle: String = "\(date.localizedWeekday), \(date.day) \(date.localizedMonth)"

        guard section % 7 == 0 else { return sectionTitle }

        return [
            (CalendarService.checkIfWeekIsEven() ? "чётная" : "нечётная") + " неделя",
            sectionTitle,
        ].joined(separator: "\n")
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let weekday = view as? UITableViewHeaderFooterView else { return }

        weekday.textLabel?.textColor = (section == self.currentWeekdayIndex) ? .lightBlue : .darkGray
        weekday.textLabel?.textColor = weekday.textLabel?.textColor.withAlphaComponent(0.8)
        weekday.textLabel?.font = .boldSystemFont(ofSize: 12)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentClassCell: StudentClassCell = tableView.dequeueReusableCell(withIdentifier: StudentClassCell.reuseId, for: indexPath) as! StudentClassCell
        let studentClass: StudentClass? = self.schedule![indexPath.section]![safeIndex: indexPath.row]

        studentClassCell.setStudentClass(studentClass)

        return studentClassCell
    }

}

extension StudentClassesScheduleController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
