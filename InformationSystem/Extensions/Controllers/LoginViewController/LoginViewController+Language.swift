//
//  LoginViewController+Language.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 28/01/2021.
//  Copyright © 2021 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAnalytics

extension LoginViewController {
    override func changeLanguageToSlovak(_ notification: Notification) {
        super.changeLanguageToSlovak(notification)
        nameOfUserData = "lang=sk&osobni=1&z=1&k=1&f=0&studijni_zpet=0&rozvrh=3187&format=html&zobraz=Zobrazi%C5%A5;lang=sk"
        languageLabel.text = "Slovenčina"
        passwordField.placeholder = "Heslo"
        loginField.placeholder = "Prihlasovacie meno (AIS)"
        loginButton.setTitle("Prihlásiť sa", for: .normal)
        languageImage.image = UIImage(named: "slovakia")
        
    }
    
    override func changeLanguageToEnglish(_ notification: Notification) {
        super.changeLanguageToEnglish(notification)
        nameOfUserData = "lang=sk&osobni=1&z=1&k=1&f=0&studijni_zpet=0&rozvrh=3187&format=html&zobraz=Zobrazi%C5%A5;lang=en"
        languageLabel.text = "English"
        passwordField.placeholder = "Password"
        loginField.placeholder = "Login (AIS)"
        loginButton.setTitle("Login", for: .normal)
        languageImage.image = UIImage(named: "uk")
    }
    
    @IBAction func changeLanguage() {
        let currentLanguage = UserDefaults.standard.value(forKey: "language")
        if currentLanguage == nil || currentLanguage as! String == "SK" {
            UserDefaults.standard.set("EN", forKey: "language")
            NotificationCenter.default.post(name: .languageEnglish, object: nil)
            Analytics.logEvent("language_EN", parameters: nil)
        } else {
            UserDefaults.standard.set("SK", forKey: "language")
            NotificationCenter.default.post(name: .languageSlovak, object: nil)
            Analytics.logEvent("language_SK", parameters: nil)
        }
    }

}
