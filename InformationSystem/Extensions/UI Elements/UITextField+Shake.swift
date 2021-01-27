//
//  UITextField+Shake.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 22/12/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import UIKit

extension UITextField {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }
}
