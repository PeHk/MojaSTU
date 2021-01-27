//
//  SideMenuViewController+CopyLabel.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 31/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension handling password copying from passwordLabel - showing the UIMenuController

import Foundation
import UIKit
import Firebase

extension SideMenuViewController {
    @objc func longPressFunction(_ gestureRecognizer: UITapGestureRecognizer) {
        passwordLabel.becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.showMenu(from: view, rect: CGRect(x: self.passwordLabel.center.x + 65, y: self.passwordLabel.center.y, width: 0.0, height: 0.0))
        }
    }

    override func copy(_ sender: Any?) {
        let board = UIPasteboard.general
        board.string = passwordLabel.text
        Analytics.logEvent("wifiPasswordCopied", parameters: nil)
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(copy(_:))
    }
    
    @objc func passwordTapped() {
        UIPasteboard.general.string = passwordLabel.text
    }
}
