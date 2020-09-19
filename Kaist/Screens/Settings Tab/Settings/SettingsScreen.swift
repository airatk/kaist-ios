//
//  SettingsScreen.swift
//  Kaist
//
//  Created by Airat K on 28/6/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class SettingsScreen: UIViewController {
    
    private let nameLabel = UILabel()
    private let instituteLabel = UILabel()
    private let yearLabel = UILabel()
    private let groupLabel = UILabel()
    private let cardLabel = UILabel()
    
    private let resetSettingsButton = UIButton()
    
    private var isSetUp = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = .systemBackground
        } else {
            self.view.backgroundColor = .white
        }
        
        self.navigationItem.title = "Настройки"
        
        self.setUpResetSettingsButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard !self.isSetUp else { return }
        
        if AppDelegate.shared.student.isFull {
            self.setUpFullUserInfo()
        } else {
            self.setUpCompactUserInfo()
        }
        
        self.isSetUp = true
    }
    
    
    private func setUpFullUserInfo() {
        self.nameLabel.text = AppDelegate.shared.student.fullName
        self.nameLabel.font = .boldSystemFont(ofSize: 22)
        self.nameLabel.numberOfLines = 0
        
        self.instituteLabel.text = AppDelegate.shared.student.instituteName
        self.instituteLabel.font = .systemFont(ofSize: 16)
        self.instituteLabel.textColor = .darkGray
        
        self.yearLabel.text = AppDelegate.shared.student.year! + " курс"
        self.yearLabel.font = .systemFont(ofSize: 16)
        self.yearLabel.textColor = .darkGray
        
        self.groupLabel.text = "группа " + AppDelegate.shared.student.groupNumber!
        self.groupLabel.font = .systemFont(ofSize: 16)
        self.groupLabel.textColor = .darkGray
        
        self.cardLabel.text = "зачётка " + AppDelegate.shared.student.card!
        self.cardLabel.font = .systemFont(ofSize: 16)
        self.cardLabel.textColor = .darkGray
        
        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.instituteLabel)
        self.view.addSubview(self.yearLabel)
        self.view.addSubview(self.groupLabel)
        self.view.addSubview(self.cardLabel)
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.instituteLabel.translatesAutoresizingMaskIntoConstraints = false
        self.yearLabel.translatesAutoresizingMaskIntoConstraints = false
        self.groupLabel.translatesAutoresizingMaskIntoConstraints = false
        self.cardLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 36),
            self.nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.nameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 36),
            
            self.instituteLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 20),
            self.instituteLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.instituteLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 36),
            
            self.yearLabel.topAnchor.constraint(equalTo: self.instituteLabel.bottomAnchor, constant: 8),
            self.yearLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.yearLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 36),
            
            self.groupLabel.topAnchor.constraint(equalTo: self.yearLabel.bottomAnchor, constant: 8),
            self.groupLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.groupLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 36),
            
            self.cardLabel.topAnchor.constraint(equalTo: self.groupLabel.bottomAnchor, constant: 8),
            self.cardLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.cardLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 36)
        ])
    }
    
    private func setUpCompactUserInfo() {
        self.groupLabel.text = "Группа " + AppDelegate.shared.student.groupNumber!
        self.groupLabel.font = .boldSystemFont(ofSize: 18)
        
        self.view.addSubview(self.groupLabel)
        self.groupLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.groupLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 36),
            self.groupLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.groupLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 36)
        ])
    }
    
    private func setUpResetSettingsButton() {
        self.resetSettingsButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        
        self.resetSettingsButton.setTitle("Выйти", for: .normal)
        
        self.resetSettingsButton.setTitleColor(.red, for: .normal)
        self.resetSettingsButton.setTitleColor(UIColor.red.withAlphaComponent(0.25), for: .highlighted)
        
        self.resetSettingsButton.layer.borderWidth = 0.8
        self.resetSettingsButton.layer.borderColor = UIColor.gray.cgColor
        self.resetSettingsButton.layer.cornerRadius = 10
        self.resetSettingsButton.clipsToBounds = true
        
        self.view.addSubview(self.resetSettingsButton)
        self.resetSettingsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.resetSettingsButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
            self.resetSettingsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.resetSettingsButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 36),
            self.resetSettingsButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        self.resetSettingsButton.addTarget(self, action: #selector(self.resetSettings), for: .touchUpInside)
    }
    
    @objc private func resetSettings() {
        AppDelegate.shared.student.reset()
        self.isSetUp = false
        
        self.nameLabel.removeFromSuperview()
        self.instituteLabel.removeFromSuperview()
        self.yearLabel.removeFromSuperview()
        self.groupLabel.removeFromSuperview()
        self.cardLabel.removeFromSuperview()
        
        self.tabBarController?.selectedIndex = 0
    }
    
}
