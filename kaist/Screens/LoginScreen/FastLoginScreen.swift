//
//  FastLoginScreen.swift
//  kaist
//
//  Created by Airat K on 13/8/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class FastLoginScreen: UIViewController {
    
    private let inputViewToolbar = UIToolbar()
    private let groupTextField = UITextField()
    private let groupFetchingIndicator = UIActivityIndicatorView()
    private let footerWarningLabel = UILabel()
    private let endLoginButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.setUpInputViewToolbar()
        self.setUpGroupTextField()
        self.setUpGroupFetchingIndicator()
        self.setUpFooterWarningLabel()
        self.setUpEndLoginButton()
    }
    
    
    private func setUpInputViewToolbar() {
        self.inputViewToolbar.tintColor = .black
        self.inputViewToolbar.barTintColor = .darkWhite
        self.inputViewToolbar.isTranslucent = false
        self.inputViewToolbar.sizeToFit()
        
        self.inputViewToolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        ], animated: false)
    }
    
    private func setUpGroupTextField() {
        self.groupTextField.delegate = self
        
        self.groupTextField.placeholder = "Введи номер группы"
        self.groupTextField.borderStyle = .roundedRect
        self.groupTextField.keyboardType = .numberPad
        self.groupTextField.inputAccessoryView = self.inputViewToolbar
        
        self.view.addSubview(self.groupTextField)
        self.groupTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.groupTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            self.groupTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.groupTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30),
            self.groupTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setUpGroupFetchingIndicator() {
        self.groupFetchingIndicator.color = .lightBlue
        
        self.groupTextField.addSubview(self.groupFetchingIndicator)
        self.groupFetchingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.groupFetchingIndicator.centerYAnchor.constraint(equalTo: self.groupTextField.centerYAnchor),
            self.groupFetchingIndicator.trailingAnchor.constraint(equalTo: self.groupTextField.trailingAnchor, constant: -15)
        ])
    }
    
    private func setUpFooterWarningLabel() {
        self.footerWarningLabel.isHidden = true
        
        self.footerWarningLabel.font = .systemFont(ofSize: 13)
        self.footerWarningLabel.textColor = .red
        self.footerWarningLabel.numberOfLines = 0
        
        self.view.addSubview(self.footerWarningLabel)
        self.footerWarningLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.footerWarningLabel.topAnchor.constraint(equalTo: self.groupTextField.bottomAnchor, constant: 18),
            self.footerWarningLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.footerWarningLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 46)
        ])
    }
    
    private func setUpEndLoginButton() {
        self.endLoginButton.setEnabled(false)
        
        self.endLoginButton.setTitle("Готово", for: .normal)
        
        self.endLoginButton.setTitleColor(.white, for: .normal)
        self.endLoginButton.setTitleColor(.lightText, for: .highlighted)
        self.endLoginButton.setTitleColor(.lightText, for: .disabled)
        
        self.endLoginButton.layer.cornerRadius = 10
        self.endLoginButton.clipsToBounds = true
        
        self.view.addSubview(self.endLoginButton)
        self.endLoginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.endLoginButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            self.endLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.endLoginButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30),
            self.endLoginButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        self.endLoginButton.addTarget(self, action: #selector(self.throwToAppController), for: .touchUpInside)
    }
    
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func throwToAppController() {
        // User cannot come here with incorrect data, so there are no error-checks
        AppDelegate.shared.student.isSetUp = true
        self.navigationController?.dismiss(animated: true)
    }
    
}

extension FastLoginScreen: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.footerWarningLabel.text = nil
        self.footerWarningLabel.isHidden = true
        
        self.endLoginButton.setEnabled(false)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard !(textField.text?.isEmpty ?? true) else { return true }
        
        self.groupFetchingIndicator.startAnimating()
        
        AppDelegate.shared.student.groupNumber = textField.text
        
        AppDelegate.shared.student.getGroupScheduleID { (groupScheduleID, error) in
            if let error = error {
                self.footerWarningLabel.text = error.rawValue
                self.footerWarningLabel.isHidden = false
            } else {
                AppDelegate.shared.student.groupScheduleID = groupScheduleID
                
                self.endLoginButton.setEnabled(true)
            }
            
            self.groupFetchingIndicator.stopAnimating()
        }
        
        return true
    }
    
}
