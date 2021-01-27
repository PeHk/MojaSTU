//
//  EIndexViewController+DarkMode.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 11/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for dark mode.

import Foundation
import UIKit

extension EIndexViewController {
//    MARK: Dark mode off
    override func darkModeDisabled(_ notification: Notification) {
        super.darkModeDisabled(notification)
        placesView.backgroundColor = .white
        testsView.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.separatorColor = .lightGray
        tableHeaderView.backgroundColor = .white
        tableFooterView.backgroundColor = .white
        semesterLabel.textColor = .black
        eIndexLabel.textColor = .black
        subjectLabel.textColor = .black
        refreshControl.tintColor = .black
        borderView.backgroundColor = UIColor.init(hex: "#E6E6E7FF")
        topBorderView.backgroundColor = UIColor.init(hex: "#E6E6E7FF")
        refreshControl.attributedTitle = NSAttributedString(string: "Načítavam...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        tableView.reloadData()
    }
//    MARK: Dark mode on
    override func darkModeEnabled(_ notification: Notification) {
        super.darkModeEnabled(notification)
        placesView.backgroundColor = .black
        testsView.backgroundColor = .black
        tableView.backgroundColor = .black
        tableView.separatorColor = .darkGray
        tableHeaderView.backgroundColor = .black
        tableFooterView.backgroundColor = .black
        semesterLabel.textColor = .white
        eIndexLabel.textColor = .white
        subjectLabel.textColor = .white
        refreshControl.tintColor = .white
        borderView.backgroundColor = .darkGray
        topBorderView.backgroundColor = .darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "Načítavam...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        tableView.reloadData()
    }
}
