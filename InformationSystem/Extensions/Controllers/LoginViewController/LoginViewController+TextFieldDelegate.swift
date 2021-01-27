//
//  LoginViewController+TextFieldDelegate.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 03/01/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension LoginViewController: UITextFieldDelegate {
    //    MARK: Textfield detailing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginField {
            textField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        }
        if textField == passwordField {
            if passwordField.returnKeyType==UIReturnKeyType.go {
                loginTapped(nil)
            }
        }
         return false
    }
}
