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
        labels.forEach { self.addArrangedSubview($0) }

        self.axis = .horizontal
        self.alignment = .center
        self.spacing = 8.0

        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 14.0).isActive = true

        let iconHeightConstraint: NSLayoutConstraint = icon.heightAnchor.constraint(equalTo: icon.widthAnchor)

        iconHeightConstraint.priority = .defaultHigh
        iconHeightConstraint.isActive = true
    }

}
