//
//  EmailViewController+Language.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 29/01/2021.
//  Copyright © 2021 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension EmailViewController {
    override func changeLanguageToSlovak(_ notification: Notification) {
        super.changeLanguageToSlovak(notification)
        emailsNameLabel.text = "Doručená pošta"
        emailsURL = "https://is.stuba.sk/auth/posta/slozka.pl?on=0;lang=sk"
        loadingString = "Načítavam..."
        noEmailsView.messageText = "V tomto priečinku nemáš žiadne správy!"
        noEmailsView.titleText = "Žiadne správy"
        noEmails.reloadState()
        reloadingEmailsView.titleText = "Načítavam..."
        messageSuccess = "Správa bola úspešne odoslaná!"
        messageFailure = "Správa nebola odoslaná!"
        errorTitle = "Nastala chyba, skontrolujte si internetové pripojenie alebo prihlasovacie údaje!"
        cancelString = "Zrušiť"
        errorMessageFirst = "Počet pokusov na pripojenie: "
        errorMessageLast = "Tlačidlom zrušiť zavriete aplikáciu!"
        errorAction = "Nastala chyba!"
        errorActionString = "Akcia nebola vykonaná!"
        blockRefresh = "Aktualizácia blokovaná"
        blockRefreshString = "Aktualizácia je možná len raz za 5 sekúnd!"
        mailboxesString = " Prečinky"
    }
    
    override func changeLanguageToEnglish(_ notification: Notification) {
        super.changeLanguageToEnglish(notification)
        emailsNameLabel.text = "Inbox"
        emailsURL = "https://is.stuba.sk/auth/posta/slozka.pl?on=0;lang=en"
        loadingString = "Refreshing..."
        noEmailsView.messageText = "You have no messages in this folder!"
        noEmailsView.titleText = "No messages"
        noEmails.reloadState()
        reloadingEmailsView.titleText = "Loading..."
        messageSuccess = "Message was succesfully sent!"
        messageFailure = "Message not sent!"
        errorTitle = "An error occurred, check your internet connection or login details!"
        cancelString = "Cancel"
        errorMessageFirst = "Connection attempts: "
        errorMessageLast = "Tap Cancel to close the application!"
        errorAction = "An error occurred!"
        errorActionString = "Action not performed!"
        blockRefresh = "Update blocked"
        blockRefreshString = "The update is only possible once every 5 seconds!"
        mailboxesString = " Mailboxes"
    }
}
