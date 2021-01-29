//
//  MailboxViewController+Language.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 29/01/2021.
//  Copyright © 2021 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension MailboxViewController {
    override func changeLanguageToSlovak(_ notification: Notification) {
        super.changeLanguageToSlovak(notification)
        language = "sk"
        emailsURL = "https://is.stuba.sk/auth/posta/slozka.pl?on=0;lang=sk"
        trashTitle = "Vysypať kôš?"
        trashText = "Naozaj si želáte vymazať všetky správy z priečinka Kôš?"
        trashAction = "Vysypať"
        cancel = "Zrušiť"
        errorTitle = "Oops!"
        errorText = "Nepodarilo sa vymazať kôš!"
        mainLabel.text = "Prečinky"
        deleteTrash.setTitle("Vysypať kôš", for: .normal)
    }
    
    override func changeLanguageToEnglish(_ notification: Notification) {
        super.changeLanguageToEnglish(notification)
        language = "en"
        emailsURL = "https://is.stuba.sk/auth/posta/slozka.pl?on=0;lang=en"
        trashTitle = "Empty the bin?"
        trashText = "Are you sure you want to delete all messages from Trash?"
        trashAction = "Empty"
        cancel = "Cancel"
        errorTitle = "Oops!"
        errorText = "Failed to clear trash!"
        mainLabel.text = "Mailboxes"
        deleteTrash.setTitle("Empty the bin", for: .normal)
        
    }
}
