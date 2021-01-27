//
//  AttachmentViewController+DarkMode.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 30/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for handling dark mode.

import Foundation
import UIKit

extension AttachmentViewController {
//    MARK: Dark mode on
    override func darkModeEnabled(_ notification: Notification) {
        super.darkModeEnabled(notification)
        tableView.backgroundColor = .black
        attachmentLabel.textColor = .white
        tableHeaderView.backgroundColor = .black
        tableFooterView.backgroundColor = .black
        tableView.reloadData()
    }
//    MARK: Dark mode off
    override func darkModeDisabled(_ notification: Notification) {
        super.darkModeDisabled(notification)
        tableView.backgroundColor = .white
        attachmentLabel.textColor = .black
        tableHeaderView.backgroundColor = .white
        tableFooterView.backgroundColor = .white
        tableView.reloadData()
    }
}
