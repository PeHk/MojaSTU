//
//  PersonalDataViewController+DarkMode.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 11/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension handling dark mode of the view.

import Foundation
import UIKit

extension PersonalDataViewController {
//    MARK: Dark mode off
    override func darkModeDisabled(_ notification: Notification) {
        super.darkModeDisabled(notification)
        activityIndicator(color: .black)
        tableView.backgroundColor = .white
        tableHeaderView.backgroundColor = .white
        headerText.textColor = .darkGray
        self.view.backgroundColor = .white
        tableFooterView.backgroundColor = .white
        tableView.reloadData()
    }
//    MARK: Dark mode on
    override func darkModeEnabled(_ notification: Notification) {
        super.darkModeEnabled(notification)
        activityIndicator(color: .white)
        tableView.backgroundColor = .black
        tableView.tableHeaderView?.backgroundColor = .black
        tableHeaderView.backgroundColor = .black
        headerText.textColor = .white
        self.view.backgroundColor = .black
        tableFooterView.backgroundColor = .black
        tableView.reloadData()
    }
//    MARK: Setting activity indicator
    func activityIndicator(color: UIColor) {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.color = color
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
}
