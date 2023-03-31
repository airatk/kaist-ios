//
//  RoundedTextField.swift
//  Kaist
//
//  Created by Airat K on 27/3/2023.
//  Copyright © 2023 Airat K. All rights reserved.
//

import Foundation
import UIKit


class RoundedTextField: UITextField {

    private let insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)


    init() {
        super.init(frame: .zero)
        self.setUpView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpView()
    }


    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds).inset(by: self.insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds).inset(by: self.insets)
    }


    private func setUpView() {
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 12
    }

}
