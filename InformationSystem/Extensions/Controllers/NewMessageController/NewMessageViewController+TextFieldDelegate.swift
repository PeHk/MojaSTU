//
//  NewMessage+TextFieldDelegate.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 03/01/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension NewMessageViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = subjectTextField.text ?? ""
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        if newText.isEmpty {
            titleTextField.text = newMessageString
        } else {
            titleTextField.text = newText
        }
        return true;
    }
}
