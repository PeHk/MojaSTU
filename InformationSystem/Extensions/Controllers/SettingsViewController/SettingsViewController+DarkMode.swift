//
//  SettingsViewController+DarkMode.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 11/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension SettingsViewController {
//    MARK: Dark mode on
    override func darkModeEnabled(_ notification: Notification) {
        super.darkModeEnabled(notification)
        activityIndicator(color: .white)
        zeroCell.backgroundColor = .black
        firstCell.backgroundColor = UIColor.black
        secondCell.backgroundColor = UIColor.black
        zeroMainLabel.textColor = .white
        firstCellLabel.textColor = .white
        secondCellLabel.textColor = .white
        secondCellText.textColor = .lightGray
        zeroSecondLabel.textColor = .lightGray
        emailControlSecondLabel.textColor = .lightGray
        thirdCell.backgroundColor = UIColor.black
        thirdCellText.textColor = .white
        emailControlCell.backgroundColor = UIColor.black
        emailControlLabel.textColor = .white
        languageCell.backgroundColor = .black
        currentLanguage.textColor = .white
        mainLabel.textColor = .white
        tableView.separatorColor = UIColor.darkGray
        tableView.reloadData()
    }
//    MARK: Dark mode off
    override func darkModeDisabled(_ notification: Notification) {
        super.darkModeDisabled(notification)
        activityIndicator(color: .black)
        zeroCell.backgroundColor = .white
        firstCell.backgroundColor = UIColor.white
        secondCell.backgroundColor = UIColor.white
        zeroMainLabel.textColor = .black
        firstCellLabel.textColor = .black
        secondCellLabel.textColor = .black
        secondCellText.textColor = .darkGray
        languageCell.backgroundColor = .white
        currentLanguage.textColor = .black
        mainLabel.textColor = .black
        zeroSecondLabel.textColor = .darkGray
        emailControlSecondLabel.textColor = .darkGray
        tableView.separatorColor = UIColor.lightGray
        thirdCell.backgroundColor = UIColor.white
        thirdCellText.textColor = .black
        emailControlCell.backgroundColor = UIColor.white
        emailControlLabel.textColor = .black
        tableView.reloadData()
    }
//    MARK: Activity indicator setup
    func activityIndicator(color: UIColor) {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.color = color
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
}
