//
//  EIndexDetailViewController+DarkMode.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 06/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for dark mode.

import Foundation
import UIKit

extension EIndexDetailViewController {
//    MARK: Dark mode off
    override func darkModeDisabled(_ notification: Notification) {
        super.darkModeDisabled(notification)
        tableView.backgroundColor = .white
        tableView.separatorColor = .lightGray
        mainTableName.textColor = .black
        subjectName.textColor = .black
        tableHeaderView.backgroundColor = .white
        tableFooterView.backgroundColor = .white
        excerciseLabel.textColor = .black
        seminarLabel.textColor = .black
        activityIndicator(color: .black)
        noPointsView.titleLabel.textColor = .black
        noPointsView.messageLabel.textColor = .black
        noPointsView.image = UIImage(named: "emptySheet")
        tableView.reloadData()
    }
//    MARK: Dark mode on
    override func darkModeEnabled(_ notification: Notification) {
        super.darkModeEnabled(notification)
        tableView.backgroundColor = .black
        tableView.separatorColor = .darkGray
        mainTableName.textColor = .white
        subjectName.textColor = .white
        tableHeaderView.backgroundColor = .black
        tableFooterView.backgroundColor = .black
        excerciseLabel.textColor = .white
        seminarLabel.textColor = .white
        activityIndicator(color: .white)
        noPointsView.titleLabel.textColor = .white
        noPointsView.messageLabel.textColor = .white
        noPointsView.image = UIImage(named: "emptySheet-white")
        tableView.reloadData()
    }
//    MARK: Activity indicator
    func activityIndicator(color: UIColor) {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.color = color
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
}
