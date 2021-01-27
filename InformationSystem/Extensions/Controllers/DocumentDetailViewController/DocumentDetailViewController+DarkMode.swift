//
//  DocumentDetailViewController+DarkMode.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 11/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension handling dark mode.

import Foundation
import UIKit

extension DocumentDetailViewController {
//    MARK: Dark mode off
    override func darkModeDisabled(_ notification: Notification) {
        super.darkModeDisabled(notification)
        tableView.backgroundColor = .white
        tableView.separatorColor = .lightGray
        tableHeaderView.backgroundColor = .white
        tableFooterView.backgroundColor = .white
        labelName.textColor = .black
        noDocumentsView.titleLabel.textColor = .black
        noDocumentsView.messageLabel.textColor = .black
        noDocumentsView.image = UIImage(named: "emptyFiles")
        tableView.reloadData()
    }
//    MARK: Dark mode on
    override func darkModeEnabled(_ notification: Notification) {
        super.darkModeEnabled(notification)
        tableView.backgroundColor = .black
        tableView.separatorColor = .darkGray
        tableHeaderView.backgroundColor = .black
        tableFooterView.backgroundColor = .black
        labelName.textColor = .white
        noDocumentsView.titleLabel.textColor = .white
        noDocumentsView.messageLabel.textColor = .white
        noDocumentsView.image = UIImage(named: "emptyFiles - white")
        tableView.reloadData()
    }
}
