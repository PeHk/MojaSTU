//
//  UViewController+DarkMode.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 10/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
        
    func initObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
    }
    
    func checkDarkMode() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        if isDarkMode {
            NotificationCenter.default.post(name: .darkModeEnabled, object: nil)
        }
        else {
            NotificationCenter.default.post(name: .darkModeDisabled, object: nil)
        }
        
    }
    
    @objc func darkModeEnabled(_ notification: Notification) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.tintColor = .white
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        self.view.backgroundColor = UIColor.black
    }
    
    @objc func darkModeDisabled(_ notification: Notification) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        self.tabBarController?.tabBar.barTintColor = UIColor.white
        self.view.backgroundColor = UIColor.white
    }
}
