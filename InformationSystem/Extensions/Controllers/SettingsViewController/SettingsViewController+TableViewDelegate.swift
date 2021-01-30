//
//  SettingsViewController+TableViewDelegate.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 03/01/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension handling table datasource and delegate.

import Foundation
import UIKit
import Firebase

extension SettingsViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            if !darkModeSwitch.isOn {
                headerView.contentView.backgroundColor = .lightGray
                headerView.textLabel?.textColor = .black
            }
            else {
                headerView.contentView.backgroundColor = .darkGray
                headerView.textLabel?.textColor = .lightGray
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            if automaticModeSwitch.isOn {
                automaticModeSwitch.setOn(false, animated: true)
                darkModeSwitch.isEnabled = true
                firstCell.isUserInteractionEnabled = true
                UserDefaults.standard.set(false, forKey: "automaticModeEnabled")
                Analytics.logEvent("automaticModeDisabled", parameters: nil)
            }
            else {
                automaticModeSwitch.setOn(true, animated: true)
                retriveCurrentLocation()
                darkModeSwitch.isEnabled = false
                firstCell.isUserInteractionEnabled = false
                UserDefaults.standard.set(true, forKey: "automaticModeEnabled")
                Analytics.logEvent("automaticModeEnabled", parameters: nil)
            }
        }
        else if indexPath.row == 1 {
            if darkModeSwitch.isOn {
                darkModeSwitch.setOn(false, animated: true)
                UserDefaults.standard.set(false, forKey: "darkModeEnabled")
                NotificationCenter.default.post(name: .darkModeDisabled, object: nil)
                Analytics.logEvent("darkModeDisabled", parameters: nil)
            }
            else {
                darkModeSwitch.setOn(true, animated: true)
                UserDefaults.standard.set(true, forKey: "darkModeEnabled")
                NotificationCenter.default.post(name: .darkModeEnabled, object: nil)
                Analytics.logEvent("darkModeEnabled", parameters: nil)
            }
        }
        else if indexPath.row == 2 {
            if emailControlSwitch.isOn {
                emailControlSwitch.setOn(false, animated: true)
                UserDefaults.standard.set(true, forKey: "emailControlDisabled")
                Analytics.logEvent("emailControlDisabled", parameters: nil)
            } else {
                let alert = UIAlertController(title: self.titleCareful, message: self.messageString, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: self.continueString, style: .default, handler: { action in
                    self.emailControlSwitch.setOn(true, animated: true)
                    UserDefaults.standard.set(false, forKey: "emailControlDisabled")
                    Analytics.logEvent("emailControlEnabled", parameters: nil)
                }))
                alert.addAction(UIAlertAction(title: self.cancelString, style: .destructive, handler: {action in
                    self.emailControlSwitch.setOn(false, animated: true)
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        else if indexPath.row == 3 {
            indicator.startAnimating()
            DispatchQueue.main.async {
                self.getSerialCode()
            }
        }
        else if indexPath.row == 4 {
            let currentLanguage = UserDefaults.standard.value(forKey: "language")
            if currentLanguage != nil {
                if currentLanguage as! String == "EN" {
                    UserDefaults.standard.set("SK", forKey: "language")
                    NotificationCenter.default.post(name: .languageSlovak, object: nil)
                    Analytics.logEvent("language_SK", parameters: nil)
                } else {
                    NotificationCenter.default.post(name: .languageEnglish, object: nil)
                    UserDefaults.standard.set("EN", forKey: "language")
                    Analytics.logEvent("language_EN", parameters: nil)
                }
            } else {
                NotificationCenter.default.post(name: .languageEnglish, object: nil)
                UserDefaults.standard.set("EN", forKey: "language")
                Analytics.logEvent("language_EN", parameters: nil)
            }
        }
        else if indexPath.row == 5 {
            if let url = URL(string: "https://pehk.github.io"){
                UIApplication.shared.open(url)
            }
        }
    }
}


