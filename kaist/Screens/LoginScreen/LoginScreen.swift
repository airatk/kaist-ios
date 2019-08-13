//
//  LoginScreen.swift
//  kaist
//
//  Created by Airat K on 12/8/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit

class LoginScreen: UIViewController {
    
    private var welcomeLabel: UILabel!
    
    private var hintLabel: UILabel!
    
    private var fullLoginButton: UIButton!
    private var fastLoginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.setUpWelcomeLabel()
        self.setUpHintLabel()
        self.setUpLoginButtons()
    }
    
    
    private func setUpWelcomeLabel() {
        self.welcomeLabel = UILabel()
        
        self.welcomeLabel.text = "Добро\nпожаловать♥️"
        self.welcomeLabel.font = .boldSystemFont(ofSize: 34)
        self.welcomeLabel.numberOfLines = 2
        
        self.view.addSubview(self.welcomeLabel)
        
        self.welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.welcomeLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.welcomeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.welcomeLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 36)
        ])
    }
    
    private func setUpHintLabel() {
        self.hintLabel = UILabel()
        
        self.hintLabel.text = [
            "Номер зачётки позволит видеть баллы — не только расписание.\n",
            "В студенческом билете он, кстати, тот же.\n\n",
            "Выбери желаемый путь настройки.\n"
        ].joined()
        self.hintLabel.font = .systemFont(ofSize: 17)
        self.hintLabel.textColor = .darkGray
        self.hintLabel.numberOfLines = 0
        
        self.view.addSubview(self.hintLabel)
        
        self.hintLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.hintLabel.topAnchor.constraint(equalTo: self.welcomeLabel.bottomAnchor, constant: 25),
            self.hintLabel.leadingAnchor.constraint(equalTo: self.welcomeLabel.leadingAnchor),
            self.hintLabel.widthAnchor.constraint(equalToConstant: 275)
        ])
    }
    
    private func setUpLoginButtons() {
        self.fullLoginButton = self.getDefaultButton()
        self.fastLoginButton = self.getDefaultButton()
        
        self.fullLoginButton.setTitle("с зачёткой", for: .normal)
        self.fastLoginButton.setTitle("без зачётки", for: .normal)
        
        self.fullLoginButton.addTarget(self, action: #selector(self.throwToFullLoginController), for: .touchUpInside)
        self.fastLoginButton.addTarget(self, action: #selector(self.throwToFastLoginController), for: .touchUpInside)
        
        self.view.addSubview(self.fullLoginButton)
        self.view.addSubview(self.fastLoginButton)
        
        self.fullLoginButton.translatesAutoresizingMaskIntoConstraints = false
        self.fastLoginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.fastLoginButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            self.fastLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.fastLoginButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30),
            self.fastLoginButton.heightAnchor.constraint(equalToConstant: 60),
            
            self.fullLoginButton.bottomAnchor.constraint(equalTo: self.fastLoginButton.topAnchor, constant: -10),
            self.fullLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.fullLoginButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30),
            self.fullLoginButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func getDefaultButton() -> UIButton {
        let defaultButton = UIButton()
        
        defaultButton.setTitleColor(.white, for: .normal)
        defaultButton.setTitleColor(.lightText, for: .highlighted)
        
        defaultButton.backgroundColor = .lightBlue
        
        defaultButton.layer.cornerRadius = 10
        defaultButton.clipsToBounds = true
        
        return defaultButton
    }
    
    
    @objc private func throwToFullLoginController() {
        self.navigationController?.pushViewController(FullLoginScreen(), animated: true)
    }
    
    @objc private func throwToFastLoginController() {
        self.navigationController?.pushViewController(FastLoginScreen(), animated: true)
    }
    
    
    @objc private func throwToAppController() {
        self.navigationController?.dismiss(animated: true)
    }
    
}
