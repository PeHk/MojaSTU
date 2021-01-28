//
//  SideMenuController+Language.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 28/01/2021.
//  Copyright © 2021 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension SideMenuViewController {
    override func changeLanguageToSlovak(_ notification: Notification) {
        super.changeLanguageToSlovak(notification)
        arrayOfSettings = ["Osobné údaje", "Nastavenia", "Odhlásiť sa"]
        errorTitle = "Nastala chyba, skontrolujte si internetové pripojenie alebo prihlasovacie údaje!"
        cancelString = "Zrušiť"
        errorMessageFirst = "Počet pokusov na pripojenie: "
        errorMessageLast = "Tlačidlom zrušiť zavriete aplikáciu!"
        informativeLabel.text = "Prihlasovacie údaje do univerzitnej siete:"
        tableView.reloadData()
    }
    
    override func changeLanguageToEnglish(_ notification: Notification) {
        super.changeLanguageToEnglish(notification)
        arrayOfSettings = ["Personal information", "Settings", "Log out"]
        errorTitle = "An error occurred, check your internet connection or login details!"
        cancelString = "Cancel"
        errorMessageFirst = "Connection attempts: "
        errorMessageLast = "Tap Cancel to close the application!"
        informativeLabel.text = "University network login details:"
        tableView.reloadData()
    }
}

