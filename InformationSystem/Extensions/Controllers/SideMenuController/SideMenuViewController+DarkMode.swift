//
//  SideMenuViewController+DarkMode.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 11/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension handling dark mode in SideMenuController

import Foundation
import UIKit

extension SideMenuViewController {
//    MARK: Dark mode off
    override func darkModeDisabled(_ notification: Notification) {
        super.darkModeDisabled(notification)
        tableHeaderView.backgroundColor = .white
        nameLabel.textColor = .black
        tableView.backgroundColor = .white
        tableView.separatorColor = UIColor.lightGray
        emailLabel.textColor = .darkGray
        passwordLabel.textColor = .darkGray
        informativeLabel.textColor = .darkGray
        tableView.tableFooterView?.backgroundColor = .white
        tableView.reloadData()
    }
//    MARK: Dark mode on
    override func darkModeEnabled(_ notification: Notification) {
        super.darkModeEnabled(notification)
        tableHeaderView.backgroundColor = .black
        nameLabel.textColor = .white
        tableView.backgroundColor = .black
        tableView.separatorColor = UIColor.darkGray
        emailLabel.textColor = .white
        passwordLabel.textColor = .white
        informativeLabel.textColor = .white
        tableView.tableFooterView?.backgroundColor = .black
        tableView.reloadData()
    }
}
