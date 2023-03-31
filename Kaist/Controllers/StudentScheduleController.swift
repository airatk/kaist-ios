//
//  StudentScheduleController.swift
//  Kaist
//
//  Created by Airat K on 28/6/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class StudentScheduleController: ExpandableTableViewController {

    private var isNextWeekSelected: Bool = false

    private var loadedSchedule: Schedule<StudentClass>?
    private var selectedSchedule: Schedule<StudentClass>?


    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.titleView = {
            let weektypeChooser = UISegmentedControl(items: [ "текущая, \(CalendarService.isWeekEven ? "чётная" : "нечётная")", "следующая" ])

            weektypeChooser.apportionsSegmentWidthsByContent = true
            weektypeChooser.selectedSegmentIndex = 0

            weektypeChooser.addTarget(self, action: #selector(self.selectWeekType), for: .valueChanged)

            return weektypeChooser
        }()

        self.refreshControl?.addTarget(self, action: #selector(self.refreshSchedule), for: .valueChanged)

        self.tableView.register(StudentClassCell.self, forCellReuseIdentifier: StudentClassCell.reuseId)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard StudentApiService.client.isSetUp else {
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

            self.loadedSchedule = nil
            self.selectedSchedule = nil
            self.tableView.reloadData()

            return
        }

        if self.loadedSchedule == nil {
            self.tableView.setContentOffset(CGPoint(x: 0, y: -100), animated: true)
            self.refreshControl?.beginRefreshing()
            self.refreshSchedule()
        }
    }

}

extension StudentScheduleController {

    private func resetSchedule() {
        self.selectedSchedule = self.loadedSchedule
    }


    @objc
    private func selectWeekType(_ sender: UISegmentedControl) {
        self.isNextWeekSelected = sender.selectedSegmentIndex == 1

        self.resetSchedule()
        self.tableView.reloadData()
    }

    @objc
    private func refreshSchedule() {
        StudentApiService.client.getSchedule(ofType: .classes) { (schedule, error) in
            if let error = error {
                self.tableView.backgroundView = EmptyView(message: error.localizedDescription)
            }

            self.loadedSchedule = schedule
            self.resetSchedule()

            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }

}

extension StudentScheduleController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        tableView.backgroundView?.isHidden = self.selectedSchedule != nil

        guard let schedule = self.selectedSchedule, !schedule.isEmpty else { return 0 }

        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedSchedule![section]!.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let weekdays: [String] = [
            "Понедельник",
            "Вторник",
            "Среда",
            "Четверг",
            "Пятница",
            "Суббота"
        ]

        let date = CalendarService.date(shiftedToDays: (section + 1) - CalendarService.currentWeekday + (self.isNextWeekSelected ? 7 : 0))

        return "\(weekdays[section]), \(date.day) \(date.month)"
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let weekday = view as? UITableViewHeaderFooterView else { return }

        weekday.textLabel?.textColor = ((section + 1) == CalendarService.currentWeekday && !self.isNextWeekSelected) ? .lightBlue : .darkGray
        weekday.textLabel?.textColor = weekday.textLabel?.textColor.withAlphaComponent(0.8)
        weekday.textLabel?.font = .boldSystemFont(ofSize: 12)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentClassCell = tableView.dequeueReusableCell(withIdentifier: StudentClassCell.reuseId, for: indexPath) as! StudentClassCell

        let studentClass = self.selectedSchedule![indexPath.section]![indexPath.row]

        studentClassCell.setStudentClass(studentClass)

        return studentClassCell
    }

}
