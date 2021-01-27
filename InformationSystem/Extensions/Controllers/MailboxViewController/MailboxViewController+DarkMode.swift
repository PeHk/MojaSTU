//
//  MailboxViewController+DarkMode.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 04/04/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension MailboxViewController {
//    MARK: Dark mode off
    override func darkModeDisabled(_ notification: Notification) {
        super.darkModeDisabled(notification)
        tableView.backgroundColor = .white
        tableFooterView.backgroundColor = .white
        tableHeaderView.backgroundColor = .white
        deleteTrash.setTitleColor(.black, for: .normal)
        mainLabel.textColor = .black
    }
//    MARK: Dark mode on
    override func darkModeEnabled(_ notification: Notification) {
        super.darkModeEnabled(notification)
        tableView.backgroundColor = .black
        tableFooterView.backgroundColor = .black
        tableHeaderView.backgroundColor = .black
        deleteTrash.setTitleColor(.white, for: .normal)
        mainLabel.textColor = .white
    }
}
