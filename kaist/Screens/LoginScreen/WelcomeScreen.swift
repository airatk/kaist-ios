//
//  WelcomeScreen.swift
//  kaist
//
//  Created by Airat K on 12/8/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class WelcomeScreen: UIViewController {
    
    private let welcomeLabel = UILabel()
    private let hintLabel = UILabel()
    
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
        self.hintLabel.text = [
            "Номер зачётки позволит видеть баллы — не только расписание.\n",
            "В студенческом билете он, кстати, тот же.\n\n",
            "Выбери желаемый путь настройки."
        ].joined()
        self.hintLabel.font = .systemFont(ofSize: 16)
        self.hintLabel.textColor = .gray
        self.hintLabel.numberOfLines = 0
        
        self.view.addSubview(self.hintLabel)
        self.hintLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.hintLabel.topAnchor.constraint(equalTo: self.welcomeLabel.bottomAnchor, constant: 25),
            self.hintLabel.leadingAnchor.constraint(equalTo: self.welcomeLabel.leadingAnchor),
            self.hintLabel.widthAnchor.constraint(equalToConstant: 260)
        ])
    }
    
    private func setUpLoginButtons() {
        self.fullLoginButton = self.getLoginButton(withTitle: "с зачёткой")
        self.fastLoginButton = self.getLoginButton(withTitle: "без зачётки")
        
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
    
    private func getLoginButton(withTitle title: String) -> UIButton {
        let loginButton = UIButton()
        
        loginButton.setTitle(title, for: .normal)
        
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(.lightText, for: .highlighted)
        
        loginButton.backgroundColor = .lightBlue
        
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        
        return loginButton
    }
    
    
    @objc private func throwToFullLoginController() {
        self.navigationController?.pushViewController(FullLoginScreen(), animated: true)
    }
    
    @objc private func throwToFastLoginController() {
        self.navigationController?.pushViewController(FastLoginScreen(), animated: true)
    }
    
}
