//
//  TimeTableViewController+DarkMode.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 11/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for dark mode handling

import Foundation
import UIKit

extension TimeTableController {
//    MARK: Dark mode off
    override func darkModeDisabled(_ notification: Notification) {
        super.darkModeDisabled(notification)
        tableHeaderView.backgroundColor = .white
        timeTableDay.textColor = .black
        tableView.backgroundColor = .white
        tableView.tableFooterView?.backgroundColor = .white
        tableView.reloadData()
        noSubjectsView.titleLabel.textColor = .black
        noSubjectsView.messageLabel.textColor = .black
        noSubjectsView.image = UIImage(named: "emptyTimeTable")
        nameDayLabel.textColor = .black
        dateLabel.textColor = .black
    }
//    MARK: Dark mode on
    override func darkModeEnabled(_ notification: Notification) {
        super.darkModeEnabled(notification)
        tableHeaderView.backgroundColor = .black
        timeTableDay.textColor = .white
        tableView.backgroundColor = .black
        tableView.tableFooterView?.backgroundColor = .black
        tableView.reloadData()
        noSubjectsView.titleLabel.textColor = .white
        noSubjectsView.messageLabel.textColor = .white
        noSubjectsView.image = UIImage(named: "emptyTimeTable - white")
        nameDayLabel.textColor = .white
        dateLabel.textColor = .white
    }
}
