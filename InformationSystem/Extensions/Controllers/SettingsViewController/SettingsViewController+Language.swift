//
//  SettingsViewController+Language.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 28/01/2021.
//  Copyright © 2021 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension SettingsViewController {
    override func changeLanguageToSlovak(_ notification: Notification) {
        super.changeLanguageToSlovak(notification)
        zeroMainLabel.text = "Automatický tmavý režim"
        zeroSecondLabel.text = "Tmavý režim sa zapne pri západe slnka a vypne pri východe slnka"
        firstCellLabel.text = "Tmavý režim"
        emailControlLabel.text = "Kontrola nových správ"
        emailControlSecondLabel.text = "Notifikácie fungujú iba, ak je appka spustená na pozadí (nie je manuálne vypnutá)"
        secondCellLabel.text = "Vygenerovať nové heslo"
        secondCellText.text = "Vygeneruje sa nové heslo do univerzitnej siete"
        mainLabel.text = "Jazyk aplikácie"
        currentLanguage.text = "Slovenčina"
        thirdCellText.text = "O aplikácií"
        continueString = "Pokračovať"
        cancelString = "Zrušiť"
        titleCareful = "Upozornenie"
        messageString = "Pokračovaním súhlasíte, že aplikácia bude používať internetové pripojenie na pozadí."
        notificationTitle = "Vygenerované nové heslo"
        notificationMessage = "Nové heslo do univerzitnej siete: "
        passwordSuccessTitle = "Úspešne zmenené!"
        passwordSuccessMessage = "Heslo bolo úspešne pregenerované!"
        passwordFailureTitle = "Chyba!"
        passwordFailureMessage = "Nastala nečakaná chyba! Heslo nebolo pregenerované!"
    }
    
    override func changeLanguageToEnglish(_ notification: Notification) {
        super.changeLanguageToEnglish(notification)
        zeroMainLabel.text = "Automatic dark mode"
        zeroSecondLabel.text = "Dark mode turns on at sunset and turns off at sunrise"
        firstCellLabel.text = "Dark mode"
        emailControlLabel.text = "Check for new messages"
        emailControlSecondLabel.text = "Notifications only work if the app is running in the background (not manually turned off)"
        secondCellLabel.text = "Generate a new password"
        secondCellText.text = "A new password will be generated for the university network"
        mainLabel.text = "Language"
        thirdCellText.text = "About"
        currentLanguage.text = "English"
        continueString = "Continue"
        cancelString = "Cancel"
        titleCareful = "Warning"
        messageString = "By continuing, you agree that the application will use the Internet connection in the background."
        notificationTitle = "New password generated"
        notificationMessage = "New university password: "
        passwordSuccessMessage = "New password successfully generated!"
        passwordSuccessTitle = "Successfully changed!"
        passwordFailureTitle = "Error!"
        passwordFailureMessage = "An unexpected error occurred! New password not generated!"
    }
}
