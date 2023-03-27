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

        self.setUpCompactUserInfo()

        self.isSetUp = true
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
