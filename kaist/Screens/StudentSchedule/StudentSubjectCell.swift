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
    
    
    public let title = UILabel()
    public let type = UILabel()
    
    public let lecturerNameTextIcon = UILabel()
    public let lecturerName = UILabel()
    
    public let departmentTextIcon = UILabel()
    public let department = UILabel()
    
    public let coordinatesTextIcon = UILabel()
    public let time = UILabel()
    public let place = UILabel()
    
    public let weekType = UILabel()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubviews()
        self.addConstraints()
        
        self.setUpViews()
    }
    
    
    override func prepareForReuse() {
        self.setUpViews()
    }
    
    
    private func setUpViews() {
        let largeFont = UIFont.boldSystemFont(ofSize: 16)
        let middleFont = UIFont.systemFont(ofSize: 14)
        let smallFont = UIFont.systemFont(ofSize: 12)
        
        self.title.text = ""
        self.title.font = largeFont
        self.title.numberOfLines = 0
        
        self.type.text = ""
        self.type.font = smallFont
        self.type.textColor = .gray
        
        self.lecturerNameTextIcon.text = "@"
        self.lecturerNameTextIcon.font = middleFont
        self.lecturerNameTextIcon.textAlignment = .center
        self.lecturerName.text = ""
        self.lecturerName.font = middleFont
        self.lecturerName.numberOfLines = 0
        
        self.departmentTextIcon.text = "§"
        self.departmentTextIcon.font = middleFont
        self.departmentTextIcon.textAlignment = .center
        self.department.text = ""
        self.department.font = middleFont
        self.department.numberOfLines = 0
        
        self.coordinatesTextIcon.text = "!"
        self.coordinatesTextIcon.font = middleFont
        self.coordinatesTextIcon.textColor = self.tintColor
        self.coordinatesTextIcon.textAlignment = .center
        self.time.text = ""
        self.time.font = smallFont
        self.time.textColor = self.tintColor
        self.place.text = ""
        self.place.font = smallFont
        self.place.textColor = .darkGray
        
        self.weekType.text = ""
        self.weekType.font = smallFont
        self.weekType.textColor = .gray
        self.weekType.numberOfLines = 0
    }
    
    private func addSubviews() {
        self.contentView.addSubview(self.title)
        self.contentView.addSubview(self.type)
        
        self.contentView.addSubview(self.lecturerNameTextIcon)
        self.contentView.addSubview(self.lecturerName)
        self.contentView.addSubview(self.departmentTextIcon)
        self.contentView.addSubview(self.department)
        
        self.contentView.addSubview(self.coordinatesTextIcon)
        self.contentView.addSubview(self.time)
        self.contentView.addSubview(self.place)
        
        self.contentView.addSubview(self.weekType)
    }
    
    private func addConstraints() {
        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([
            self.title.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            self.title.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.title.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
        self.type.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([
            self.type.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: 3.5),
            self.type.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.type.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
        
        self.lecturerNameTextIcon.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([
            self.lecturerNameTextIcon.topAnchor.constraint(equalTo: self.lecturerName.topAnchor),
            self.lecturerNameTextIcon.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.lecturerNameTextIcon.widthAnchor.constraint(equalTo: self.lecturerNameTextIcon.heightAnchor, multiplier: 1)
        ])
        self.lecturerName.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([
            self.lecturerName.topAnchor.constraint(equalTo: self.type.bottomAnchor, constant: 10),
            self.lecturerName.leadingAnchor.constraint(equalTo: self.lecturerNameTextIcon.trailingAnchor, constant: 4),
            self.lecturerName.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
        self.departmentTextIcon.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([
            self.departmentTextIcon.topAnchor.constraint(equalTo: self.department.topAnchor),
            self.departmentTextIcon.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.departmentTextIcon.widthAnchor.constraint(equalTo: self.departmentTextIcon.heightAnchor, multiplier: 1)
        ])
        self.department.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([
            self.department.topAnchor.constraint(equalTo: self.lecturerName.bottomAnchor, constant: 5),
            self.department.leadingAnchor.constraint(equalTo: self.departmentTextIcon.trailingAnchor, constant: 4),
            self.department.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
        
        self.coordinatesTextIcon.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([
            self.coordinatesTextIcon.centerYAnchor.constraint(equalTo: self.time.centerYAnchor),
            self.coordinatesTextIcon.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.coordinatesTextIcon.widthAnchor.constraint(equalTo: self.coordinatesTextIcon.heightAnchor, multiplier: 1)
        ])
        self.time.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([
            self.time.topAnchor.constraint(equalTo: self.department.bottomAnchor, constant: 10),
            self.time.leadingAnchor.constraint(equalTo: self.coordinatesTextIcon.trailingAnchor, constant: 4)
        ])
        self.place.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([
            self.place.topAnchor.constraint(equalTo: self.time.topAnchor),
            self.place.leadingAnchor.constraint(equalTo: self.time.trailingAnchor, constant: 8)
        ])
        
        
        self.weekType.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([
            self.weekType.topAnchor.constraint(equalTo: self.time.bottomAnchor, constant: 8),
            self.weekType.leadingAnchor.constraint(equalTo: self.time.leadingAnchor),
            self.weekType.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
        self.contentView.layoutMarginsGuide.bottomAnchor.constraint(equalTo: self.weekType.bottomAnchor, constant: 8).isActive = true
    }

}
