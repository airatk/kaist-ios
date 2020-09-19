//
//  UIImageViewExtension.swift
//  Kaist
//
//  Created by Airat K on 21/8/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


extension UIImageView {
    
    open func setTintColor(_ tintColor: UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = tintColor
    }
    
}
