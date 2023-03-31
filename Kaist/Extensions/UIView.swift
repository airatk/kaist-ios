//
//  UIViewExtenstion.swift
//  Kaist
//
//  Created by Airat K on 27/3/2023.
//  Copyright © 2023 Airat K. All rights reserved.
//

import Foundation
import UIKit


extension UIView {

    static func popAnimate(animations: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 500.0, initialSpringVelocity: 0.0, animations: animations)
    }

}

extension UIView {

    func hideChangingTransparency() {
        self.alpha = 0.0
        self.isHidden = true
    }

    func showChangingTransparency() {
        self.alpha = 1.0
        self.isHidden = false
    }

}

extension UIView {

    func shake(for duration: TimeInterval = 0.2, withTranslation translation: Float = 4, count: Float = 3) {
        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")

        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.repeatCount = count
        animation.duration = duration / TimeInterval(count)
        animation.autoreverses = true
        animation.values = [ translation, -translation ]

        self.layer.add(animation, forKey: "shake")
    }

}
