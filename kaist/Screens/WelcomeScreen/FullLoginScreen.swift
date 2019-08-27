//
//  FullLoginScreen.swift
//  kaist
//
//  Created by Airat K on 13/8/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class FullLoginScreen: UIViewController {
    
    private var instituteTextFieldTopConstraint: NSLayoutConstraint!
    
    private let instituteTextField = UITextField()
    private let yearTextField = UITextField()
    private let groupTextField = UITextField()
    private let nameTextField = UITextField()
    private let cardTextField = UITextField()
    
    private let inputViewToolbar = UIToolbar()
    
    private let institutePicker = UIPickerView()
    private let yearPicker = UIPickerView()
    private let groupPicker = UIPickerView()
    private let namePicker = UIPickerView()
    
    private let instituteFetchingIndicator = UIActivityIndicatorView()
    private let yearFetchingIndicator = UIActivityIndicatorView()
    private let groupFetchingIndicator = UIActivityIndicatorView()
    private let cardFetchingIndicator = UIActivityIndicatorView()
    
    private let footerWarningLabel = UILabel()
    
    private let endLoginButton = UIButton()
    
    private let institutes = AppDelegate.shared.student.institutes
    private var years: Student.StudentData!
    private var groups: Student.StudentData!
    private var names: Student.StudentData!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.setUpTextFields()
        self.setUpActivityIndicators()
        self.setUpInputViews()
        
        self.setUpFooterWarningLabel()
        self.setUpEndLoginButton()
    }
    
    
    private func setUpTextFields() {
        self.instituteTextField.delegate = self
        self.yearTextField.delegate = self
        self.groupTextField.delegate = self
        self.nameTextField.delegate = self
        self.cardTextField.delegate = self
        
        self.instituteTextField.placeholder = "Выбери подразделение"
        
        self.instituteTextField.borderStyle = .roundedRect
        self.yearTextField.borderStyle = .roundedRect
        self.groupTextField.borderStyle = .roundedRect
        self.nameTextField.borderStyle = .roundedRect
        self.cardTextField.borderStyle = .roundedRect
        
        self.instituteTextField.inputView = self.institutePicker
        self.yearTextField.inputView = self.yearPicker
        self.groupTextField.inputView = self.groupPicker
        self.nameTextField.inputView = self.namePicker
        self.cardTextField.keyboardType = .numberPad
        
        self.yearTextField.isEnabled = false
        self.groupTextField.isEnabled = false
        self.nameTextField.isEnabled = false
        self.cardTextField.isEnabled = false
        
        self.view.addSubview(self.instituteTextField)
        self.view.addSubview(self.yearTextField)
        self.view.addSubview(self.groupTextField)
        self.view.addSubview(self.nameTextField)
        self.view.addSubview(self.cardTextField)
        self.instituteTextField.translatesAutoresizingMaskIntoConstraints = false
        self.yearTextField.translatesAutoresizingMaskIntoConstraints = false
        self.groupTextField.translatesAutoresizingMaskIntoConstraints = false
        self.nameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.cardTextField.translatesAutoresizingMaskIntoConstraints = false
        
        self.instituteTextFieldTopConstraint = self.instituteTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15)
        
        NSLayoutConstraint.activate([
            self.instituteTextFieldTopConstraint,
            self.instituteTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.instituteTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30),
            self.instituteTextField.heightAnchor.constraint(equalToConstant: 60),
            
            self.yearTextField.topAnchor.constraint(equalTo: self.instituteTextField.bottomAnchor, constant: 10),
            self.yearTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.yearTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30),
            self.yearTextField.heightAnchor.constraint(equalToConstant: 60),
            
            self.groupTextField.topAnchor.constraint(equalTo: self.yearTextField.bottomAnchor, constant: 10),
            self.groupTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.groupTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30),
            self.groupTextField.heightAnchor.constraint(equalToConstant: 60),
            
            self.nameTextField.topAnchor.constraint(equalTo: self.groupTextField.bottomAnchor, constant: 10),
            self.nameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.nameTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30),
            self.nameTextField.heightAnchor.constraint(equalToConstant: 60),
            
            self.cardTextField.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 10),
            self.cardTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.cardTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30),
            self.cardTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setUpActivityIndicators() {
        self.instituteFetchingIndicator.color = .lightBlue
        self.yearFetchingIndicator.color = .lightBlue
        self.groupFetchingIndicator.color = .lightBlue
        self.cardFetchingIndicator.color = .lightBlue
        
        self.instituteTextField.addSubview(self.instituteFetchingIndicator)
        self.yearTextField.addSubview(self.yearFetchingIndicator)
        self.groupTextField.addSubview(self.groupFetchingIndicator)
        self.cardTextField.addSubview(self.cardFetchingIndicator)
        self.instituteFetchingIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.yearFetchingIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.groupFetchingIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.cardFetchingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.instituteFetchingIndicator.centerYAnchor.constraint(equalTo: self.instituteTextField.centerYAnchor),
            self.instituteFetchingIndicator.trailingAnchor.constraint(equalTo: self.instituteTextField.trailingAnchor, constant: -15),
            
            self.yearFetchingIndicator.centerYAnchor.constraint(equalTo: self.yearTextField.centerYAnchor),
            self.yearFetchingIndicator.trailingAnchor.constraint(equalTo: self.yearTextField.trailingAnchor, constant: -15),
            
            self.groupFetchingIndicator.centerYAnchor.constraint(equalTo: self.groupTextField.centerYAnchor),
            self.groupFetchingIndicator.trailingAnchor.constraint(equalTo: self.groupTextField.trailingAnchor, constant: -15),
            
            self.cardFetchingIndicator.centerYAnchor.constraint(equalTo: self.cardTextField.centerYAnchor),
            self.cardFetchingIndicator.trailingAnchor.constraint(equalTo: self.cardTextField.trailingAnchor, constant: -15)
        ])
    }
    
    private func setUpInputViews() {
        self.institutePicker.delegate = self
        self.yearPicker.delegate = self
        self.groupPicker.delegate = self
        self.namePicker.delegate = self
        
        self.inputViewToolbar.tintColor = .black
        self.inputViewToolbar.barTintColor = .darkWhite
        self.inputViewToolbar.isTranslucent = false
        self.inputViewToolbar.sizeToFit()
        self.inputViewToolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        ], animated: false)
        
        self.instituteTextField.inputAccessoryView = self.inputViewToolbar
        self.yearTextField.inputAccessoryView = self.inputViewToolbar
        self.groupTextField.inputAccessoryView = self.inputViewToolbar
        self.nameTextField.inputAccessoryView = self.inputViewToolbar
        self.cardTextField.inputAccessoryView = self.inputViewToolbar
    }
    
    
    private func setUpFooterWarningLabel() {
        self.footerWarningLabel.isHidden = true
        
        self.footerWarningLabel.font = .systemFont(ofSize: 13)
        self.footerWarningLabel.textColor = .red
        self.footerWarningLabel.numberOfLines = 0
        
        self.view.addSubview(self.footerWarningLabel)
        self.footerWarningLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.footerWarningLabel.topAnchor.constraint(equalTo: self.cardTextField.bottomAnchor, constant: 18),
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
            self.endLoginButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        self.endLoginButton.addTarget(self, action: #selector(self.throwToAppController), for: .touchUpInside)
    }
    
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func throwToAppController() {
        // User cannot come here with incorrect data, so there are no error-checks
        AppDelegate.shared.student.isSetUp = true
        AppDelegate.shared.student.isFull = true
        
        self.navigationController?.dismiss(animated: true)
    }
    
}

extension FullLoginScreen: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.footerWarningLabel.isHidden = true
        self.footerWarningLabel.text = nil
        
        switch textField {
            case self.instituteTextField:
                self.yearTextField.text = nil
                self.yearTextField.placeholder = nil
                self.yearTextField.isEnabled = false
                
                fallthrough
            case self.yearTextField:
                self.groupTextField.text = nil
                self.groupTextField.placeholder = nil
                self.groupTextField.isEnabled = false
                
                fallthrough
            case self.groupTextField:
                self.nameTextField.text = nil
                self.nameTextField.placeholder = nil
                self.nameTextField.isEnabled = false
                
                fallthrough
            case self.nameTextField:
                self.cardTextField.text = nil
                self.cardTextField.placeholder = nil
                self.cardTextField.isEnabled = false
                
                fallthrough
            case self.cardTextField:
                fallthrough
            default:
                self.endLoginButton.setEnabled(false)
        }
        
        if textField.text?.isEmpty ?? true {
            var studentDataPicker: UIPickerView {
                switch textField {
                    case self.instituteTextField: return self.institutePicker
                    case self.yearTextField: return self.yearPicker
                    case self.groupTextField: return self.groupPicker
                    case self.nameTextField: return self.namePicker
                    
                    default: return UIPickerView()
                }
            }
            
            studentDataPicker.delegate?.pickerView?(studentDataPicker, didSelectRow: 0, inComponent: 0)
        }
        
        self.didChangeKeyboardVisibility(isHidden: false, beingAtTextField: textField)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField {
            case self.instituteTextField:
                self.instituteFetchingIndicator.startAnimating()
                
                AppDelegate.shared.student.instituteName = textField.text
                AppDelegate.shared.student.instituteID = self.institutes[textField.text]
                
                AppDelegate.shared.student.getData(ofType: .years) { (years, error) in
                    if let error = error {
                        self.footerWarningLabel.text = error.rawValue
                        self.footerWarningLabel.isHidden = false
                    } else {
                        self.years = years
                        
                        self.yearTextField.placeholder = "Выбери курс"
                        self.yearTextField.isEnabled = true
                    }
                    
                    self.didChangeKeyboardVisibility(isHidden: true, beingAtTextField: textField)
                    self.instituteFetchingIndicator.stopAnimating()
                }
            case self.yearTextField:
                self.yearFetchingIndicator.startAnimating()
                
                AppDelegate.shared.student.year = textField.text
                
                AppDelegate.shared.student.getData(ofType: .groups) { (groups, error) in
                    if let error = error {
                        self.footerWarningLabel.text = error.rawValue
                        self.footerWarningLabel.isHidden = false
                    } else {
                        self.groups = groups
                        
                        self.groupTextField.placeholder = "Выбери группу"
                        self.groupTextField.isEnabled = true
                    }
                    
                    self.didChangeKeyboardVisibility(isHidden: true, beingAtTextField: textField)
                    self.yearFetchingIndicator.stopAnimating()
                }
            case self.groupTextField:
                self.groupFetchingIndicator.startAnimating()
                
                AppDelegate.shared.student.groupNumber = textField.text
                AppDelegate.shared.student.groupScoreID = self.groups[textField.text!]
                
                AppDelegate.shared.student.getGroupScheduleID { (groupScheduleID, error) in
                    if let error = error {
                        self.footerWarningLabel.text = error.rawValue
                        self.footerWarningLabel.isHidden = false

                        self.didChangeKeyboardVisibility(isHidden: true, beingAtTextField: textField)
                        self.groupFetchingIndicator.stopAnimating()
                    } else {
                        AppDelegate.shared.student.groupScheduleID = groupScheduleID
                
                        AppDelegate.shared.student.getData(ofType: .names) { (names, error) in
                            if let error = error {
                                self.footerWarningLabel.text = error.rawValue
                                self.footerWarningLabel.isHidden = false
                            } else {
                                self.names = names
                                
                                self.nameTextField.placeholder = "Выбери себя"
                                self.nameTextField.isEnabled = true
                            }
                            
                            self.didChangeKeyboardVisibility(isHidden: true, beingAtTextField: textField)
                            self.groupFetchingIndicator.stopAnimating()
                        }
                    }
                }
            case self.nameTextField:
                AppDelegate.shared.student.fullName = textField.text
                AppDelegate.shared.student.ID = self.names[textField.text!]
                
                self.cardTextField.placeholder = "Введи номер зачётки"
                self.cardTextField.isEnabled = true
                self.didChangeKeyboardVisibility(isHidden: true, beingAtTextField: textField)
            case self.cardTextField:
                guard !(textField.text?.isEmpty ?? true) else {
                    self.didChangeKeyboardVisibility(isHidden: true, beingAtTextField: textField)
                    break
                }
                
                self.cardFetchingIndicator.startAnimating()
                
                AppDelegate.shared.student.card = textField.text
                
                AppDelegate.shared.student.getLastAvailableSemester { (_, error) in
                    if error == nil {
                        self.endLoginButton.setEnabled(true)
                    } else {
                        self.footerWarningLabel.text = "Номер зачётки неверен"
                        self.footerWarningLabel.isHidden = false
                    }
                    
                    self.didChangeKeyboardVisibility(isHidden: true, beingAtTextField: textField)
                    self.cardFetchingIndicator.stopAnimating()
                }
            
            default: break
        }
        
        return true
    }
    
    
    private func didChangeKeyboardVisibility(isHidden: Bool, beingAtTextField textField: UITextField) {
        self.view.layoutIfNeeded()  // The below animation should be applied only for below changes
        
        let offset = self.view.safeAreaLayoutGuide.layoutFrame.origin.y - textField.frame.origin.y + 30
        self.instituteTextFieldTopConstraint.constant = isHidden ? 15 : offset
        
        if textField != self.instituteTextField {
            self.navigationItem.setHidesBackButton(true, animated: true)
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            guard textField != self.instituteTextField else { return }
            self.navigationItem.setHidesBackButton(!isHidden, animated: true)
        })
    }
    
}

extension FullLoginScreen: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
            case self.institutePicker: return self.institutes.count
            case self.yearPicker: return self.years.count
            case self.groupPicker: return self.groups.count
            case self.namePicker: return self.names.count
            
            default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
            case self.institutePicker: return self.institutes.sorted { Int($0.value)! < Int($1.value)! } .map { $0.key } [row]
            case self.yearPicker: return self.years.sorted { $0.key < $1.key } .map { $0.key } [row]
            case self.groupPicker: return self.groups.sorted { $0.key < $1.key } .map { $0.key } [row]
            case self.namePicker: return self.names.sorted { $0.key < $1.key } .map { $0.key } [row]
            
            default: return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
            case self.institutePicker: self.instituteTextField.text = self.institutes.sorted { Int($0.value)! < Int($1.value)! } .map { $0.key } [row]
            case self.yearPicker: self.yearTextField.text = self.years.sorted { $0.key < $1.key } .map { $0.key } [row]
            case self.groupPicker: self.groupTextField.text = self.groups.sorted { $0.key < $1.key } .map { $0.key } [row]
            case self.namePicker: self.nameTextField.text = self.names.sorted { $0.key < $1.key } .map { $0.key } [row]
            
            default: break
        }
    }
    
}
