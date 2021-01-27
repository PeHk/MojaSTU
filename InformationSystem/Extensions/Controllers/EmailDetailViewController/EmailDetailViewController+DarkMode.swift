//
//  EmailDetailViewController+DarkMode.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 11/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for dark mode handling.

import Foundation
import UIKit

extension EmailDetailViewController {
//    MARK: Dark mode off
    override func darkModeDisabled(_ notification: Notification) {
        super.darkModeDisabled(notification)
        borderView.backgroundColor = .white
        subjectName.textColor = .black
        emailText.textColor = .black
        emailText.backgroundColor = .white
        senderName.textColor = .black
        dateLabel.textColor = .black
        timeLabel.textColor = .black
        activityIndicator(color: .black)
    }
//    MARK: Dark mode on
    override func darkModeEnabled(_ notification: Notification) {
        super.darkModeEnabled(notification)
        borderView.backgroundColor = .black
        subjectName.textColor = .white
        emailText.backgroundColor = .black
        emailText.textColor = .white
        senderName.textColor = .white
        dateLabel.textColor = .white
        timeLabel.textColor = .white
        activityIndicator(color: .white)
    }
//    MARK: Scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let isDarkMode = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        if isDarkMode {
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.barTintColor = UIColor.black
        }
        else {
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        }
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
