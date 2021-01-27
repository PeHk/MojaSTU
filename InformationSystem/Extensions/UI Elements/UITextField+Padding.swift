//
//  UITextField+Padding.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 21/12/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import UIKit

extension UITextField {
    
    func setPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setBottomBorder(){
        
    }
}

