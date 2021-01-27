//
//  TestViewController+DarkMode.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 03/06/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension TestsViewController {
//    MARK: Dark mode off
    override func darkModeDisabled(_ notification: Notification) {
        super.darkModeDisabled(notification)
        tableView.backgroundColor = .white
        tableHeaderView.backgroundColor = .white
        tableFooterView.backgroundColor = .white
        mainLabel.textColor = .black
        emptyStateView.titleLabel.textColor = .black
        emptyStateView.messageLabel.textColor = .black
        emptyStateView.image = UIImage(named: "test-black")
        refreshControl.tintColor = .black
        refreshControl.attributedTitle = NSAttributedString(string: "Načítavam...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        tableView.reloadData()
    }
//    MARK: Dark mode on
    override func darkModeEnabled(_ notification: Notification) {
        super.darkModeEnabled(notification)
        tableView.backgroundColor = .black
        tableHeaderView.backgroundColor = .black
        tableFooterView.backgroundColor = .black
        mainLabel.textColor = .white
        emptyStateView.titleLabel.textColor = .white
        emptyStateView.messageLabel.textColor = .white
        emptyStateView.image = UIImage(named: "test-white")
        refreshControl.tintColor = .white
        refreshControl.attributedTitle = NSAttributedString(string: "Načítavam...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        tableView.reloadData()
    }
}

