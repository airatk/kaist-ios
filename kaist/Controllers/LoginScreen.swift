//
//  LoginScreen.swift
//  kaist
//
//  Created by Airat K on 28/6/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit

class LoginScreen: UIViewController {
    
    @IBOutlet weak var instituteTextField: UITextField!
    
    let institutes = [ "ИАНТЭ", "ФМФ", "ИАЭП", "ИКТЗИ", "ИРЭТ", "ИЭУСТ" ]
    // KIT option gotta be implemented separately
    
    override func viewDidLoad() {
        super.viewDidLoad()

        instituteTextField.inputView = getInstitutePicker()
        instituteTextField.inputAccessoryView = getToolbar()
    }
    
    func getInstitutePicker() -> UIPickerView {
        let institutePicker = UIPickerView()
        
        institutePicker.delegate = self
        
        return institutePicker
    }
    
    func getToolbar() -> UIToolbar {
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissInstitutePicker))
        
        toolBar.sizeToFit()
        toolBar.setItems([ doneButton ], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    @objc func dismissInstitutePicker() {
        view.endEditing(true)
    }

}

extension LoginScreen: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return institutes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return institutes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        instituteTextField.text = institutes[row]
    }

}
