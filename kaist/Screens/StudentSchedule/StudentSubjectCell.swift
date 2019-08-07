//
//  SubjectCell.swift
//  kaist
//
//  Created by Airat K on 17/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class StudentSubjectCell: UITableViewCell {
    
    static let ID = "SubjectCell"
    
    private let iconSize: CGFloat = 14
    private let iconRightMagrin: CGFloat = 8
    
    public let title = UILabel()
    public let type = UILabel()
    public let lecturerIcon = UIImageView(image: UIImage(named: "lecturer"))
    public let lecturer = UILabel()
    public let departmentIcon = UIImageView(image: UIImage(named: "department"))
    public let department = UILabel()
    public let coordinatesIcon = UIImageView(image: UIImage(named: "coordinates"))
    public let time = UILabel()
    public let place = UILabel()
    public let dates = UILabel()
    
    private var departmentToLecturerConstraint = NSLayoutConstraint()
    private var departmentToTypeConstraint = NSLayoutConstraint()
    
    private var bottomToDatesConstraint = NSLayoutConstraint()
    private var bottomToTimeConstraint = NSLayoutConstraint()
    private var bottomToTitleConstraint = NSLayoutConstraint()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setUpSubviews()
        self.addSubviews()
    }
    
}

extension StudentSubjectCell {
    
    private func setUpSubviews() {
        let largeFont = UIFont.boldSystemFont(ofSize: 16)
        let middleFont = UIFont.systemFont(ofSize: 14)
        let smallFont = UIFont.systemFont(ofSize: 12)
        
        self.title.font = largeFont
        self.title.numberOfLines = 0
        
        self.type.font = smallFont
        self.type.textColor = .gray
        
        self.lecturerIcon.set(tintColor: .darkGray)
        self.lecturer.font = middleFont
        self.lecturer.numberOfLines = 0
        
        self.departmentIcon.set(tintColor: .darkGray)
        self.department.font = middleFont
        self.department.numberOfLines = 0
        
        self.coordinatesIcon.set(tintColor: self.tintColor)
        self.time.font = smallFont
        self.time.textColor = self.tintColor
        self.place.font = smallFont
        self.place.textColor = .darkGray
        
        self.dates.font = smallFont
        self.dates.textColor = .gray
        self.dates.numberOfLines = 0
    }
    
    private func addSubviews() {
        self.contentView.addSubview(self.title)
        self.title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.title.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            self.title.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.title.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
        self.contentView.addSubview(self.type)
        self.type.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.type.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: 3.5),
            self.type.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.type.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
        self.contentView.addSubview(self.lecturerIcon)
        self.contentView.addSubview(self.lecturer)
        self.lecturerIcon.translatesAutoresizingMaskIntoConstraints = false
        self.lecturer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.lecturerIcon.centerYAnchor.constraint(equalTo: self.lecturer.centerYAnchor),
            self.lecturerIcon.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.lecturerIcon.widthAnchor.constraint(equalToConstant: self.iconSize),
            self.lecturerIcon.heightAnchor.constraint(equalTo: self.lecturerIcon.widthAnchor, multiplier: 1),
            self.lecturer.topAnchor.constraint(equalTo: self.type.bottomAnchor, constant: 8),
            self.lecturer.leadingAnchor.constraint(equalTo: self.lecturerIcon.trailingAnchor, constant: iconRightMagrin),
            self.lecturer.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
        self.contentView.addSubview(self.departmentIcon)
        self.contentView.addSubview(self.department)
        self.departmentIcon.translatesAutoresizingMaskIntoConstraints = false
        self.department.translatesAutoresizingMaskIntoConstraints = false
        self.departmentToLecturerConstraint = self.department.topAnchor.constraint(equalTo: self.lecturer.bottomAnchor, constant: 5)
        self.departmentToTypeConstraint = self.department.topAnchor.constraint(equalTo: self.type.bottomAnchor, constant: 8)
        NSLayoutConstraint.activate([
            self.departmentIcon.topAnchor.constraint(equalTo: self.department.topAnchor, constant: 1.75),
            self.departmentIcon.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.departmentIcon.widthAnchor.constraint(equalToConstant: self.iconSize),
            self.departmentIcon.heightAnchor.constraint(equalTo: self.departmentIcon.widthAnchor, multiplier: 1),
            self.departmentToLecturerConstraint,
            self.department.leadingAnchor.constraint(equalTo: self.departmentIcon.trailingAnchor, constant: iconRightMagrin),
            self.department.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
        self.contentView.addSubview(self.coordinatesIcon)
        self.contentView.addSubview(self.time)
        self.contentView.addSubview(self.place)
        self.coordinatesIcon.translatesAutoresizingMaskIntoConstraints = false
        self.time.translatesAutoresizingMaskIntoConstraints = false
        self.place.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.coordinatesIcon.centerYAnchor.constraint(equalTo: self.time.centerYAnchor),
            self.coordinatesIcon.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.coordinatesIcon.widthAnchor.constraint(equalToConstant: self.iconSize),
            self.coordinatesIcon.heightAnchor.constraint(equalTo: self.coordinatesIcon.widthAnchor, multiplier: 1),
            self.time.topAnchor.constraint(equalTo: self.department.bottomAnchor, constant: 6),
            self.time.leadingAnchor.constraint(equalTo: self.coordinatesIcon.trailingAnchor, constant: iconRightMagrin),
            self.place.centerYAnchor.constraint(equalTo: self.time.centerYAnchor),
            self.place.leadingAnchor.constraint(equalTo: self.time.trailingAnchor, constant: 8)
        ])
        
        self.contentView.addSubview(self.dates)
        self.dates.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.dates.topAnchor.constraint(equalTo: self.time.bottomAnchor, constant: 10),
            self.dates.leadingAnchor.constraint(equalTo: self.time.leadingAnchor),
            self.dates.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
        self.bottomToDatesConstraint = self.contentView.bottomAnchor.constraint(equalTo: self.dates.bottomAnchor, constant: 12)
        self.bottomToTimeConstraint = self.contentView.bottomAnchor.constraint(equalTo: self.time.bottomAnchor, constant: 12)
        self.bottomToTitleConstraint = self.contentView.heightAnchor.constraint(equalToConstant: 44)
        NSLayoutConstraint.activate([
            self.bottomToDatesConstraint
        ])
    }
    
}

extension StudentSubjectCell {
    
    public enum Subviews {
        case dates
        case lecturer
        case allButTitle
    }
    
    public func hide(_ subview: StudentSubjectCell.Subviews) {
        switch subview {
            case .dates:
                self.dates.isHidden = true

                self.bottomToDatesConstraint.isActive = false
                self.bottomToTitleConstraint.isActive = false
                self.bottomToTimeConstraint.isActive = true
            case .lecturer:
                self.lecturerIcon.isHidden = true
                self.lecturer.isHidden = true

                self.departmentToLecturerConstraint.isActive = false
                self.departmentToTypeConstraint.isActive = true
            case .allButTitle:
                self.type.isHidden = true
                self.lecturerIcon.isHidden = true
                self.lecturer.isHidden = true
                self.departmentIcon.isHidden = true
                self.department.isHidden = true
                self.coordinatesIcon.isHidden = true
                self.time.isHidden = true
                self.place.isHidden = true
                self.dates.isHidden = true

                self.bottomToDatesConstraint.isActive = false
                self.bottomToTimeConstraint.isActive = false
                self.bottomToTitleConstraint.isActive = true
        }
    }

}

extension StudentSubjectCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.title.text = ""
        
        self.type.isHidden = false
        self.type.text = ""
        
        self.lecturerIcon.isHidden = false
        self.lecturer.isHidden = false
        self.lecturer.text = ""
        
        self.departmentIcon.isHidden = false
        self.department.isHidden = false
        self.department.text = ""
        self.departmentToTypeConstraint.isActive = false
        self.departmentToLecturerConstraint.isActive = true
        
        self.coordinatesIcon.isHidden = false
        self.time.isHidden = false
        self.time.text = ""
        self.place.isHidden = false
        self.place.text = ""
        
        self.dates.isHidden = false
        self.dates.text = ""
        
        self.bottomToTitleConstraint.isActive = false
        self.bottomToTimeConstraint.isActive = false
        self.bottomToDatesConstraint.isActive = true
    }
    
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        self.contentView.backgroundColor = highlighted ? self.tintColor.withAlphaComponent(0.1) : .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        self.setHighlighted(selected, animated: animated)
    }
    
}


extension UIImageView {
    
    func set(tintColor: UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = tintColor
    }
    
}
