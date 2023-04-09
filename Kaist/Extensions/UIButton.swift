//
//  UIButton.swift
//  Kaist
//
//  Created by Airat K on 15/8/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


extension UIButton {

    public func setEnabled(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
        self.backgroundColor = isEnabled ? .lightBlue : .dimmedBlue
    }

}

extension UIButton {

    func addActivityIndicator(_ activityIndicator: UIActivityIndicatorView) {
        self.addSubview(activityIndicator)

        activityIndicator.center = self.center
        activityIndicator.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
    }

}
