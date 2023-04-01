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
        icon.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(icon)

        for label in labels {
            self.addArrangedSubview(label)
        }

        self.axis = .horizontal
        self.spacing = 8

        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 14),
            icon.heightAnchor.constraint(equalTo: icon.widthAnchor, multiplier: 1),
        ])
    }

}
