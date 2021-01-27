//
//  NewMessageViewController+DarkMode.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 11/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension NewMessageViewController {
    override func darkModeDisabled(_ notification: Notification) {
        super.darkModeDisabled(notification)
        cancelButton.setTitleColor(.black, for: .normal)
        titleTextField.textColor = .black
        subjectTextField.textColor = .black
        subjectTextField.attributedPlaceholder = NSAttributedString(string: "Predmet:",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        emailTextField.textColor = .black
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Príjemca:",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        messageTextView.backgroundColor = .white
        messageTextView.textColor = .black
    }
    
    override func darkModeEnabled(_ notification: Notification) {
        super.darkModeEnabled(notification)
        cancelButton.setTitleColor(.white, for: .normal)
        titleTextField.textColor = .white
        subjectTextField.textColor = .white
        subjectTextField.attributedPlaceholder = NSAttributedString(string: "Predmet:",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailTextField.textColor = .white
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Príjemca:",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        messageTextView.backgroundColor = .black
        messageTextView.textColor = .white
    }
}
