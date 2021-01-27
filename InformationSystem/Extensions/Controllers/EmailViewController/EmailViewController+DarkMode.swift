//
//  EmailViewController+DarkMode.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 11/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for handling dark mode.

import Foundation
import UIKit

extension EmailViewController {
//    MARK: Dark mode off
    override func darkModeDisabled(_ notification: Notification) {
        super.darkModeDisabled(notification)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        tableView.backgroundColor = .white
        tableView.separatorColor = .lightGray
        emailsNameLabel.textColor = .black
        tableHeaderView.backgroundColor = .white
        tableFooterView.backgroundColor = .white
        refreshControl.tintColor = .black
        refreshControl.attributedTitle = NSAttributedString(string: "Načítavam...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        noEmailsView.titleLabel.textColor = .black
        noEmailsView.messageLabel.textColor = .black
        noEmailsView.image = UIImage(named: "emptyFiles")
        reloadingEmailsView.titleLabel.textColor = .black
        reloadingEmailsView.messageLabel.textColor = .black
        reloadingEmailsView.image = UIImage(named: "reload")
        tableView.reloadData()
    }
//    MARK: Dark mode on
    override func darkModeEnabled(_ notification: Notification) {
        super.darkModeEnabled(notification)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        tableView.backgroundColor = .black
        tableView.separatorColor = UIColor.darkGray
        emailsNameLabel.textColor = .white
        tableHeaderView.backgroundColor = .black
        tableFooterView.backgroundColor = .black
        refreshControl.tintColor = .white
        refreshControl.attributedTitle = NSAttributedString(string: "Načítavam...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        noEmailsView.titleLabel.textColor = .white
        noEmailsView.messageLabel.textColor = .white
        noEmailsView.image = UIImage(named: "emptyFiles - white")
        reloadingEmailsView.titleLabel.textColor = .white
        reloadingEmailsView.messageLabel.textColor = .white
        reloadingEmailsView.image = UIImage(named: "reloadWhite")
        tableView.reloadData()
    }
}
