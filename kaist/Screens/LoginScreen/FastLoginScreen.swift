//
//  FastLoginScreen.swift
//  kaist
//
//  Created by Airat K on 13/8/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class FastLoginScreen: UIViewController {
    
    private let groupTextField = UITextField()
    private let activityIndicator = UIActivityIndicatorView()
    private let groupTextFieldFooterLabel = UILabel()
    private let endLoginButton = UIButton()
    
    private var groupScheduleID: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.setUpGroupTextField()
        self.setUpActivityIndicator()
        self.setUpGroupTextFieldFooterLabel()
        self.setUpEndLoginButton()
    }
    
    
    private func setUpGroupTextField() {
        self.groupTextField.delegate = self
        
        self.groupTextField.placeholder = "Введи номер группы"
        self.groupTextField.keyboardType = .numberPad
        self.groupTextField.borderStyle = .roundedRect
        
        self.view.addSubview(self.groupTextField)
        
        self.groupTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.groupTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            self.groupTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.groupTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30),
            self.groupTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
    }
    
    private func setUpActivityIndicator() {
        self.activityIndicator.color = .lightBlue
        
        self.groupTextField.addSubview(self.activityIndicator)
        
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.groupTextField.centerYAnchor),
            self.activityIndicator.trailingAnchor.constraint(equalTo: self.groupTextField.trailingAnchor, constant: -15)
        ])
    }
    
    private func setUpGroupTextFieldFooterLabel() {
        self.groupTextFieldFooterLabel.isHidden = true
        
        self.groupTextFieldFooterLabel.font = .systemFont(ofSize: 14)
        self.groupTextFieldFooterLabel.textColor = .red
        self.groupTextFieldFooterLabel.numberOfLines = 0
        
        self.view.addSubview(self.groupTextFieldFooterLabel)
        
        self.groupTextFieldFooterLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.groupTextFieldFooterLabel.topAnchor.constraint(equalTo: self.groupTextField.bottomAnchor, constant: 20),
            self.groupTextFieldFooterLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.groupTextFieldFooterLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 46)
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
            self.endLoginButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            self.endLoginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.endLoginButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30),
            self.endLoginButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        self.endLoginButton.addTarget(self, action: #selector(self.throwToAppController), for: .touchUpInside)
    }
    
    
    @objc private func dismissKeyboard() {
        self.groupTextField.resignFirstResponder()
    }
    
    @objc private func throwToAppController() {
        // Can not be nil because the host button appears only if self.groupScheduleID is correct
        AppDelegate.shared.student.groupScheduleID = self.groupScheduleID
        AppDelegate.shared.student.isSetUp = true
        
        self.navigationController?.dismiss(animated: true)
    }
    
}

extension FastLoginScreen: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.groupTextFieldFooterLabel.isHidden = true
        self.endLoginButton.setEnabled(false)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard !(textField.text?.isEmpty ?? true) else { return true }
        
        self.activityIndicator.startAnimating()
        
        AppDelegate.shared.student.groupNumber = textField.text
        AppDelegate.shared.student.getGroupScheduleID { (groupScheduleID, error) in
            if let error = error {
                self.groupTextFieldFooterLabel.text = error.rawValue.lowercased()
                self.groupTextFieldFooterLabel.isHidden = false
            } else {
                self.groupScheduleID = groupScheduleID
                
                self.groupTextFieldFooterLabel.text = nil
                self.groupTextFieldFooterLabel.isHidden = true
                
                self.endLoginButton.setEnabled(true)
            }
            
            self.activityIndicator.stopAnimating()
        }
        
        return true
    }
    
}


extension UIButton {
    
    open func setEnabled(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
        self.backgroundColor = isEnabled ? .lightBlue : .dimmedBlue
    }
    
}
