//
//  SubjectCell.swift
//  kaist
//
//  Created by Airat K on 17/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit

class SubjectCell: UITableViewCell {

    static let subjectCellID = "SubjectCell"
    
    private let minimalMargin: CGFloat = 5

    public let title = UILabel()
    public let type = UILabel()
    public let lecturerNameTextIcon = UILabel()
    public let lecturerName = UILabel()
    public let departmentTextIcon = UILabel()
    public let department = UILabel()
    public let time = UILabel()
    public let place = UILabel()
    public let weekType = UILabel()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setUpViews()
        self.addSubviews()
        self.setUpConstraints()
    }
    
    
    private func setUpViews() {
        self.title.font = .boldSystemFont(ofSize: 16)
        self.title.numberOfLines = 0
        
        self.type.font = .systemFont(ofSize: 12)
        self.type.textColor = .gray
        
        self.lecturerName.font = .systemFont(ofSize: 14)
        self.lecturerName.numberOfLines = 0
        self.lecturerNameTextIcon.text = "@"
        self.lecturerNameTextIcon.textAlignment = .center
        self.lecturerNameTextIcon.font = self.lecturerName.font
        
        self.department.font = .systemFont(ofSize: 14)
        self.department.numberOfLines = 0
        self.departmentTextIcon.text = "§"
        self.departmentTextIcon.textAlignment = .center
        self.departmentTextIcon.font = self.department.font
        
        self.time.font = .systemFont(ofSize: 12)
        self.time.textColor = self.time.tintColor
        
        self.place.font = .systemFont(ofSize: 12)
        self.place.textColor = .gray
    }
    
    private func addSubviews() {
        self.contentView.addSubview(self.title)
        self.contentView.addSubview(self.type)
        
        self.contentView.addSubview(self.lecturerNameTextIcon)
        self.contentView.addSubview(self.lecturerName)
        self.contentView.addSubview(self.departmentTextIcon)
        self.contentView.addSubview(self.department)
        
        self.contentView.addSubview(self.time)
        self.contentView.addSubview(self.place)
        
        #warning("Add weektype")
    }
    
    private func setUpConstraints() {
        self.title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.title.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            self.title.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.title.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
        self.type.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.type.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: self.minimalMargin),
            self.type.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.type.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
        
        self.lecturerNameTextIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.lecturerNameTextIcon.topAnchor.constraint(equalTo: self.type.bottomAnchor, constant: self.minimalMargin*2),
            self.lecturerNameTextIcon.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.lecturerNameTextIcon.widthAnchor.constraint(equalTo: self.lecturerNameTextIcon.heightAnchor, multiplier: 1)
        ])
        self.lecturerName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.lecturerName.topAnchor.constraint(equalTo: self.lecturerNameTextIcon.topAnchor),
            self.lecturerName.leadingAnchor.constraint(equalTo: self.lecturerNameTextIcon.trailingAnchor, constant: self.minimalMargin),
            self.lecturerName.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
        self.departmentTextIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.departmentTextIcon.topAnchor.constraint(equalTo: self.lecturerNameTextIcon.bottomAnchor, constant: self.minimalMargin*3/2),
            self.departmentTextIcon.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.departmentTextIcon.widthAnchor.constraint(equalTo: self.lecturerNameTextIcon.widthAnchor)
        ])
        self.department.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.department.topAnchor.constraint(equalTo: self.departmentTextIcon.topAnchor),
            self.department.leadingAnchor.constraint(equalTo: self.departmentTextIcon.trailingAnchor, constant: self.minimalMargin),
            self.department.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
        
        self.time.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.time.topAnchor.constraint(equalTo: self.department.bottomAnchor, constant: self.minimalMargin*2),
            self.time.leadingAnchor.constraint(equalTo: self.department.leadingAnchor)
        ])
        
        self.place.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.place.topAnchor.constraint(equalTo: self.time.topAnchor),
            self.place.leadingAnchor.constraint(equalTo: self.time.trailingAnchor, constant: self.minimalMargin*2)
        ])
        
        
        self.contentView.layoutMarginsGuide.bottomAnchor.constraint(equalTo: self.place.bottomAnchor, constant: self.minimalMargin).isActive = true
    }

}
