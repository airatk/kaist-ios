//
//  UIStackViewExtension.swift
//  Kaist
//
//  Created by Airat K on 1/4/2023.
//  Copyright © 2023 Airat K. All rights reserved.
//

import UIKit


extension UIStackView {

    func setUpAsIconRow(usingIcon icon: UIImageView, usingLabels labels: UILabel...) {
        self.addArrangedSubview(icon)
        for label in labels {
            self.addArrangedSubview(label)
        }

        self.axis = .horizontal
        self.alignment = .center
        self.spacing = 8.0

        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 14.0).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
    }

}
