//
//  SettingsScreen.swift
//  kaist
//
//  Created by Airat K on 28/6/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class SettingsScreen: UIViewController {
    
    private let resetSettingsButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Настройки"
        
        self.setUpResetSettingsButton()
    }
    
    
    private func setUpResetSettingsButton() {
        self.resetSettingsButton.setTitle("Reset", for: .normal)
        self.resetSettingsButton.setTitleColor(.red, for: .normal)
        
        self.view.addSubview(self.resetSettingsButton)
        
        self.resetSettingsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.resetSettingsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.resetSettingsButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.resetSettingsButton.widthAnchor.constraint(equalToConstant: 120),
            self.resetSettingsButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        self.resetSettingsButton.addTarget(self, action: #selector(self.resetSettings), for: .touchUpInside)
    }
    
    @objc private func resetSettings() {
        AppDelegate.shared.student.reset()
    }
    
}
