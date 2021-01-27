//
//  NotificationsViewController+DarkMode.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 11/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for dark mode.

import Foundation
import UIKit

extension PersonViewController {
//    MARK: Dark mode on
    override func darkModeEnabled(_ notification: Notification) {
        super.darkModeEnabled(notification)
        activityIndicator(color: .white)
        peopleLabel.textColor = .white
        headerView.backgroundColor = .black
        tableView.backgroundColor = .black
        tableFooterView.backgroundColor = .black
        tableView.separatorColor = .darkGray
        searchBar.barTintColor = .black
        searchBar.searchTextField.textColor = .white
        tableView.reloadData()
        startSearchView.titleLabel.textColor = .white
        startSearchView.messageLabel.textColor = .white
        startSearchView.image = UIImage(named: "contact-white")
        emptyStateView.titleLabel.textColor = .white
        emptyStateView.messageLabel.textColor = .white
        emptyStateView.image?.withTintColor(.white)
        emptyStateView.image = UIImage(named: "undefined-white")
    }
//    MARK: Dark mode off
    override func darkModeDisabled(_ notification: Notification) {
        super.darkModeDisabled(notification)
        activityIndicator(color: .black)
        peopleLabel.textColor = .black
        searchBar.barTintColor = .white
        searchBar.searchTextField.textColor = .black
        headerView.backgroundColor = .white
        tableView.backgroundColor = .white
        tableFooterView.backgroundColor = .white
        tableView.separatorColor = .lightGray
        tableView.reloadData()
        startSearchView.titleLabel.textColor = .black
        startSearchView.messageLabel.textColor = .black
        startSearchView.image?.withTintColor(.black)
        startSearchView.image = UIImage(named: "contact")
        emptyStateView.titleLabel.textColor = .black
        emptyStateView.messageLabel.textColor = .black
        emptyStateView.image?.withTintColor(.black)
        emptyStateView.image = UIImage(named: "undefined")
    }
    
    func activityIndicator(color: UIColor) {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.color = color
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
}
