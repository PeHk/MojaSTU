//
//  PlacesViewController+Language.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 28/01/2021.
//  Copyright © 2021 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension PlacesViewController {
    override func changeLanguageToSlovak(_ notification: Notification) {
        super.changeLanguageToSlovak(notification)
        mainLabel.text = "Miesta odovzdania"
        emptyStateView.messageText = "Nemáte žiadne miesta odovzdania"
        emptyStateView.titleText = "Žiadne miesta odovzdania!"
        errorTitle = "Nastala chyba, skontrolujte si internetové pripojenie alebo prihlasovacie údaje!"
        cancelString = "Zrušiť"
        errorMessageFirst = "Počet pokusov na pripojenie: "
        errorMessageLast = "Tlačidlom zrušiť zavriete aplikáciu!"
        language = "sk"
        mainURL = "https://is.stuba.sk/auth/student/odevzdavarny.pl?lang=sk"
    }
    
    override func changeLanguageToEnglish(_ notification: Notification) {
        super.changeLanguageToEnglish(notification)
        mainLabel.text = "Submissions"
        emptyStateView.messageText = "You have no upload locations"
        emptyStateView.titleText = "No upload locations!"
        errorTitle = "An error occurred, check your internet connection or login details!"
        cancelString = "Cancel"
        errorMessageFirst = "Connection attempts: "
        errorMessageLast = "Tap Cancel to close the application!"
        language = "en"
        mainURL = "https://is.stuba.sk/auth/student/odevzdavarny.pl?lang=en"
    }
}
