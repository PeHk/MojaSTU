//
//  DocumentDetailViewController+Language.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 28/01/2021.
//  Copyright © 2021 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension DocumentDetailViewController {
    override func changeLanguageToSlovak(_ notification: Notification) {
        super.changeLanguageToSlovak(notification)
        noDocumentsView.messageText = "Pre tento predmet nemáš žiadne dokumenty"
        noDocumentsView.titleLabel.text = "Žiadne dokumenty"
        errorTitle = "Nastala chyba, skontrolujte si internetové pripojenie alebo prihlasovacie údaje!"
        cancelString = "Zrušiť"
        errorMessageFirst = "Počet pokusov na pripojenie: "
        errorMessageLast = "Tlačidlom zrušiť zavriete aplikáciu!"
        downloadLabel.text = "Sťahujem..."
    }
    
    override func changeLanguageToEnglish(_ notification: Notification) {
        super.changeLanguageToEnglish(notification)
        noDocumentsView.messageText = "You have no documents for this subject"
        noDocumentsView.titleLabel.text = "No documents"
        errorTitle = "An error occurred, check your internet connection or login details!"
        cancelString = "Cancel"
        errorMessageFirst = "Connection attempts: "
        errorMessageLast = "Tap Cancel to close the application!"
        downloadLabel.text = "Downloading..."
    }
}
