//
//  PersonDetailTableViewController+Language.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 28/01/2021.
//  Copyright © 2021 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension PersonDetailTableViewController {
    override func changeLanguageToSlovak(_ notification: Notification) {
        super.changeLanguageToSlovak(notification)
        nameStatic.text = "Meno:"
        studyStatic.text = "Štúdium:"
        contactLabel.text = "Kontakt:"
        errorTitle = "Nastala chyba, skontrolujte si internetové pripojenie alebo prihlasovacie údaje!"
        cancelString = "Zrušiť"
        errorMessageFirst = "Počet pokusov na pripojenie: "
        errorMessageLast = "Tlačidlom zrušiť zavriete aplikáciu!"
        messageSentString = "Správa bola úspešne odoslaná!"
        messageNotSentString = "Správa nebola odoslaná!"
    }
    
    override func changeLanguageToEnglish(_ notification: Notification) {
        super.changeLanguageToEnglish(notification)
        nameStatic.text = "Name:"
        studyStatic.text = "Study:"
        contactLabel.text = "Contact:"
        errorTitle = "An error occurred, check your internet connection or login details!"
        cancelString = "Cancel"
        errorMessageFirst = "Connection attempts: "
        errorMessageLast = "Tap Cancel to close the application!"
        messageSentString = "Message was succesfully sent!"
        messageNotSentString = "Message not sent!"
    }
}
