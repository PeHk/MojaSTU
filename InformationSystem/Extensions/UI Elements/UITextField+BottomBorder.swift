//
//  UITextField+BottomBorder.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 03/01/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setBottomBorder(withColor color: UIColor)
    {
        self.borderStyle = UITextField.BorderStyle.none
        self.backgroundColor = UIColor.clear
        let width: CGFloat = 0.5

        let borderLine = UIView(frame: CGRect(x: 0, y: self.frame.height - width - 5, width: self.frame.width, height: width))
        borderLine.backgroundColor = color
        self.addSubview(borderLine)
    }
}
