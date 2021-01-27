//
//  PersonDetailViewController.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 22/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension PersonDetailTableViewController {
    override func darkModeEnabled(_ notification: Notification) {
        super.darkModeEnabled(notification)
        nameLabel.textColor = .white
        idLabel.textColor = .white
        studyLabel.textColor = .white
        idStatic.textColor = .white
        nameStatic.textColor = .white
        studyStatic.textColor = .white
        appEmailLabel.textColor = .white
        outEmailLabel.textColor = .white
        activityOut.color = .white
        activityIn.color = .white
        contactLabel.textColor = .white
        photoCell.backgroundColor = .black
        infoCell.backgroundColor = .black
        buttonsCell.backgroundColor = .black
    }
    
    override func darkModeDisabled(_ notification: Notification) {
        super.darkModeDisabled(notification)
        nameLabel.textColor = .black
        idLabel.textColor = .black
        studyLabel.textColor = .black
        idStatic.textColor = .black
        nameStatic.textColor = .black
        studyStatic.textColor = .black
        appEmailLabel.textColor = .black
        outEmailLabel.textColor = .black
        activityOut.color = .black
        activityIn.color = .black
        contactLabel.textColor = .black
        photoCell.backgroundColor = .white
        infoCell.backgroundColor = .white
        buttonsCell.backgroundColor = .white
    }
}
