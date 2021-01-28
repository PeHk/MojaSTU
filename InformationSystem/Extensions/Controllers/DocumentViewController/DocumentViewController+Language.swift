//
//  DocumentViewController+Language.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 28/01/2021.
//  Copyright © 2021 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension DocumentViewController {
    override func changeLanguageToSlovak(_ notification: Notification) {
        super.changeLanguageToSlovak(notification)
        documentLabel.text = "Dokumenty"
        mainURL = "https://is.stuba.sk/auth/student/list.pl?;lang=sk"
        mainMarksURL = "https://is.stuba.sk/auth/student/pruchod_studiem.pl?;lang=sk"
        errorTitle = "Nastala chyba, skontrolujte si internetové pripojenie alebo prihlasovacie údaje!"
        cancelString = "Zrušiť"
        errorMessageFirst = "Počet pokusov na pripojenie: "
        errorMessageLast = "Tlačidlom zrušiť zavriete aplikáciu!"
        
    }
    
    override func changeLanguageToEnglish(_ notification: Notification) {
        super.changeLanguageToEnglish(notification)
        documentLabel.text = "Documents"
        mainURL = "https://is.stuba.sk/auth/student/list.pl?;lang=en"
        mainMarksURL = "https://is.stuba.sk/auth/student/pruchod_studiem.pl?;lang=en"
        errorTitle = "An error occurred, check your internet connection or login details!"
        cancelString = "Cancel"
        errorMessageFirst = "Connection attempts: "
        errorMessageLast = "Tap Cancel to close the application!"
    }
}
