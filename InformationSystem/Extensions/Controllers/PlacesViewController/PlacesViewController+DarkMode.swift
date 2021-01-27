//
//  PlacesViewController+DarkMode.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 08/04/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension PlacesViewController {
//    MARK: Dark mode off
    override func darkModeDisabled(_ notification: Notification) {
        super.darkModeDisabled(notification)
        tableView.backgroundColor = .white
        tableHeaderView.backgroundColor = .white
        tableFooterView.backgroundColor = .white
        mainLabel.textColor = .black
        emptyStateView.titleLabel.textColor = .black
        emptyStateView.messageLabel.textColor = .black
        emptyStateView.image = UIImage(named: "places")
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
        emptyStateView.image = UIImage(named: "places-white")
        tableView.reloadData()
    }
}
