//
//  StudentClassCell.swift
//  Kaist
//
//  Created by Airat K on 17/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class StudentClassCell: UITableViewCell {

    static let reuseId = "StudentClassCell"

    private let contentStackView: UIStackView = UIStackView()

    private let titleStackView: UIStackView = UIStackView()
    private let title = UILabel()
    private let type = UILabel()

    private let lecturerStackView: UIStackView = UIStackView()
    private let lecturerIcon = UIImageView(image: UIImage(named: "Lecturer"))
    private let lecturer = UILabel()

    private let departmentUnitStackView: UIStackView = UIStackView()
    private let departmentUnitIcon = UIImageView(image: UIImage(named: "Department"))
    private let departmentUnit = UILabel()

    private let coordinatesStackView: UIStackView = UIStackView()
    private let coordinatesIcon = UIImageView(image: UIImage(named: "Coordinates"))
    private let startTime = UILabel()
    private let place = UILabel()

    private let dates = UILabel()


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        self.contentView.addSubview(self.contentStackView)

        self.setUpContentStackView()
    }


    override func prepareForReuse() {
        super.prepareForReuse()

        self.title.text = nil
        self.type.text = nil
        self.lecturer.text = nil
        self.departmentUnit.text = nil
        self.startTime.text = nil
        self.place.text = nil
        self.dates.text = nil

        self.type.isHidden = false
        self.lecturerStackView.isHidden = false
        self.departmentUnitStackView.isHidden = false
        self.coordinatesStackView.isHidden = false
        self.dates.isHidden = false
    }

}

extension StudentClassCell {

    func setStudentClass(_ studentClass: StudentClass) {
        self.title.text = studentClass.discipline

        guard studentClass.isActualClass else {
            self.hide(.allButTitle)
            return
        }

        self.type.text = studentClass.type
        
        if studentClass.lecturer.isEmpty {
            self.hide(.lecturer)
        } else {
            self.lecturer.text = studentClass.lecturer
        }
        self.departmentUnit.text = studentClass.departmentUnit
        self.startTime.text = studentClass.startTime

        if studentClass.auditorium.isEmpty {
            self.place.text = studentClass.building
        } else {
            self.place.text = [ studentClass.building, studentClass.auditorium ].joined(separator: ", ")
        }

        if studentClass.dates.isEmpty {
            self.hide(.dates)
        } else {
            self.dates.text = studentClass.dates
        }
    }

}

private extension StudentClassCell {

    enum SubviewsToHide {

        case allButTitle
        case lecturer
        case dates

    }

    func hide(_ subviewsToHide: SubviewsToHide) {
        switch subviewsToHide {
        case .allButTitle:
            self.type.isHidden = true
            self.lecturerStackView.isHidden = true
            self.departmentUnitStackView.isHidden = true
            self.coordinatesStackView.isHidden = true
            self.dates.isHidden = true
        case .lecturer:
            self.lecturerStackView.isHidden = true
        case .dates:
            self.dates.isHidden = true
        }
    }

}

private extension StudentClassCell {

    func setUpContentStackView() {
        self.contentStackView.axis = .vertical
        self.contentStackView.spacing = 8

        self.contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.contentStackView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            self.contentStackView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            self.contentStackView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.contentStackView.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
        ])

        self.contentStackView.addArrangedSubview(self.titleStackView)
        self.contentStackView.addArrangedSubview(self.lecturerStackView)
        self.contentStackView.addArrangedSubview(self.departmentUnitStackView)
        self.contentStackView.addArrangedSubview(self.coordinatesStackView)
        self.contentStackView.addArrangedSubview(self.dates)

        self.setUpTitleStackView()
        self.setUpLecturerStackView()
        self.setUpDepartmentUnit()
        self.setUpCoordinatesStackView()
        self.setUpDates()
    }

    func setUpTitleStackView() {
        self.titleStackView.axis = .vertical
        self.titleStackView.spacing = 3

        self.titleStackView.addArrangedSubview(self.title)
        self.titleStackView.addArrangedSubview(self.type)

        self.title.font = .largeFont
        self.title.numberOfLines = 0

        self.type.font = .smallFont
        self.type.textColor = .gray
    }

    func setUpLecturerStackView() {
        self.lecturerStackView.setUpAsIconRow(usingIcon: self.lecturerIcon, usingLabels: self.lecturer)

        self.lecturerIcon.setTintColor(.darkGray)

        self.lecturer.font = .middleFont
        self.lecturer.numberOfLines = 0
    }

    func setUpDepartmentUnit() {
        self.departmentUnitStackView.setUpAsIconRow(usingIcon: self.departmentUnitIcon, usingLabels: self.departmentUnit)

        self.departmentUnitIcon.setTintColor(.darkGray)

        self.departmentUnit.font = .middleFont
        self.departmentUnit.numberOfLines = 0
    }

    func setUpCoordinatesStackView() {
        self.coordinatesStackView.setUpAsIconRow(usingIcon: self.coordinatesIcon, usingLabels: self.startTime, self.place)

        self.coordinatesIcon.setTintColor(.lightBlue)

        self.startTime.font = .smallFont
        self.startTime.textColor = .lightBlue

        self.place.font = .smallFont
        self.place.textColor = .gray
    }

    func setUpDates() {
        self.dates.font = .smallFont
        self.dates.textColor = .gray
        self.dates.numberOfLines = 0
    }

}
