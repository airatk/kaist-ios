//
//  StudentScheduleController.swift
//  Kaist
//
//  Created by Airat K on 28/6/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class StudentScheduleController: ExpandableTableViewController {

    private let currentWeekdayIndex: Int = CalendarService.getWeekdayIndex()

    private var schedule: Schedule<StudentClass>?


    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Занятия"

        self.refreshControl?.addTarget(self, action: #selector(self.refreshSchedule), for: .valueChanged)

        self.tableView.register(StudentClassCell.self, forCellReuseIdentifier: StudentClassCell.reuseId)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard StudentApiService.client.isSignedIn else {
            self.present({
                let welcomeScreen: UINavigationController = UINavigationController(rootViewController: WelcomeController())
                let emptyImage: UIImage = UIImage()

                welcomeScreen.navigationBar.setBackgroundImage(emptyImage, for: .default)
                welcomeScreen.navigationBar.shadowImage = emptyImage

                if #available(iOS 13.0, *) {
                    welcomeScreen.isModalInPresentation = true
                }

                return welcomeScreen
            }(), animated: true)

            self.schedule = nil
            self.tableView.reloadData()

            return
        }

        if self.schedule == nil {
            self.tableView.setContentOffset(CGPoint(x: 0, y: -100), animated: true)
            self.refreshControl?.beginRefreshing()
            self.refreshSchedule()
        }
    }

}

extension StudentScheduleController {

    @objc
    private func refreshSchedule() {
        StudentApiService.client.getSchedule(ofType: .classes) { (schedule, error) in
            if let error = error {
                self.tableView.backgroundView = EmptyView(message: error.localizedDescription)
            }

            self.schedule = schedule

            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }

}

extension StudentScheduleController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        tableView.backgroundView?.isHidden = self.schedule != nil

        guard let schedule = self.schedule, !schedule.isEmpty else { return 0 }

        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schedule![section]!.count
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
        let studentClassCell = tableView.dequeueReusableCell(withIdentifier: StudentClassCell.reuseId, for: indexPath) as! StudentClassCell
        let studentClass = self.schedule![indexPath.section]![indexPath.row]

        studentClassCell.setStudentClass(studentClass)

        return studentClassCell
    }

}

extension StudentScheduleController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
