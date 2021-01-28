//
//  LoginViewController+DarkMode.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 26/01/2021.
//  Copyright © 2021 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension LoginViewController {
//    MARK: Dark mode off
    override func darkModeDisabled(_ notification: Notification) {
        super.darkModeDisabled(notification)
        backgroundImage.image = UIImage(named: "Background")
        universityLogo.image = UIImage(named: "STUlogo")
        informationLabel.textColor = .black
        indicator.color = UIColor.black
        passwordField.backgroundColor = UIColor.white
        loginField.backgroundColor = UIColor.white
        languageLabel.textColor = .black
    }
//    MARK: Dark mode on
    override func darkModeEnabled(_ notification: Notification) {
        super.darkModeEnabled(notification)
        backgroundImage.image = UIImage(named: "Background_dark")
        universityLogo.image = UIImage(named: "STULogo_white")
        informationLabel.textColor = UIColor.white
        indicator.color = UIColor.white
        passwordField.backgroundColor = UIColor.lightGray
        loginField.backgroundColor = UIColor.lightGray
        languageLabel.textColor = .white
    }
}
