//
//  DocumentViewController+DarkMode.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 11/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension handling dark mode.

import Foundation
import UIKit

extension DocumentViewController {
//    MARK: Dark mode off
    override func darkModeDisabled(_ notification: Notification) {
        super.darkModeDisabled(notification)
        tableView.backgroundColor = .white
        tableView.separatorColor = .lightGray
        tableHeaderView.backgroundColor = .white
        tableFooterView.backgroundColor = .white
        documentLabel.textColor = .black
        tableView.reloadData()
    }
//    MARK: Dark mode on
    override func darkModeEnabled(_ notification: Notification) {
        super.darkModeEnabled(notification)
        tableView.backgroundColor = .black
        tableView.separatorColor = .darkGray
        tableHeaderView.backgroundColor = .black
        tableFooterView.backgroundColor = .black
        documentLabel.textColor = .white
        tableView.reloadData()
    }
}
