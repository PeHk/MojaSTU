//
//  EmailDetailViewController+Language.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 29/01/2021.
//  Copyright © 2021 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension EmailDetailViewController {
    override func changeLanguageToSlovak(_ notification: Notification) {
        super.changeLanguageToSlovak(notification)
        errorTitle = "Nastala chyba, skontrolujte si internetové pripojenie alebo prihlasovacie údaje!"
        cancelString = "Zrušiť"
        errorMessageFirst = "Počet pokusov na pripojenie: "
        errorMessageLast = "Tlačidlom zrušiť zavriete aplikáciu!"
        alertTitle = "Niečo sa pokazilo!"
        alertText = "Prosím reštartujte aplikáciu!"
    }
    
    override func changeLanguageToEnglish(_ notification: Notification) {
        super.changeLanguageToEnglish(notification)
        errorTitle = "An error occurred, check your internet connection or login details!"
        cancelString = "Cancel"
        errorMessageFirst = "Connection attempts: "
        errorMessageLast = "Tap Cancel to close the application!"
        alertTitle = "Something went wrong!"
        alertText = "Please try to reset the application!"
    }
}
