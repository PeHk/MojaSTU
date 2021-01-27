//
//  EmailDetailViewController+DarkMode.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 09/06/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for dark mode handling.

import Foundation
import UIKit

extension PlacesDownloadViewController {
//    MARK: Dark mode off
    override func darkModeDisabled(_ notification: Notification) {
        super.darkModeDisabled(notification)
        tableLabel.textColor = .black
        tableHeaderView.backgroundColor = .white
        tableFooterView.backgroundColor = .white
        tableView.backgroundColor = .white
        controllerLabel.textColor = .black
        nameLabel.textColor = .black
        endDateLabel.textColor = .black
        subjectLabel.textColor = .black
        uploadDateLabel.textColor = .black
        pointsLabel.textColor = .black
        staticName.textColor = .black
        staticEndDate.textColor = .black
        staticPoints.textColor = .black
        staticSubject.textColor = .black
        staticUploadDate.textColor = .black
        staticSuccessLabel.textColor = .black
        activityIndicator(color: .black)
        tableView.reloadData()
    }
//    MARK: Dark mode on
    override func darkModeEnabled(_ notification: Notification) {
        super.darkModeEnabled(notification)
        tableLabel.textColor = .white
        controllerLabel.textColor = .white
        tableHeaderView.backgroundColor = .black
        tableFooterView.backgroundColor = .black
        tableView.backgroundColor = .black
        nameLabel.textColor = .white
        endDateLabel.textColor = .white
        subjectLabel.textColor = .white
        uploadDateLabel.textColor = .white
        pointsLabel.textColor = .white
        staticName.textColor = .white
        staticEndDate.textColor = .white
        staticPoints.textColor = .white
        staticSubject.textColor = .white
        staticUploadDate.textColor = .white
        staticSuccessLabel.textColor = .white
        activityIndicator(color: .white)
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
