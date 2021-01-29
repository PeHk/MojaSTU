//
//  NewMessageController+Language.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 29/01/2021.
//  Copyright © 2021 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension NewMessageViewController {
    override func changeLanguageToSlovak(_ notification: Notification) {
        super.changeLanguageToSlovak(notification)
        newMessageString = "Nová správa"
        cancelString = "Zrušiť"
        sendString = "Odoslať"
        emailTextField.placeholder = "Príjemca"
        subjectTextField.placeholder = "Predmet"
        noRecipientTitle = "Nevyplnili ste príjemcu!"
        noRecipientText = "Doplňte príjemcov správy a skúste znova."
        conceptTitle = "Koncept"
        conceptText = "Želáte si zahodiť rozpísanú správu?"
        conceptCancel = "Zahodiť koncept"
        incompleteTitle = "Nekompletná správa!"
        incompleteText = "Chcete odoslať správu bez predmetu alebo textu v tele?"
    }
    
    override func changeLanguageToEnglish(_ notification: Notification) {
        super.changeLanguageToEnglish(notification)
        newMessageString = "New message"
        cancelString = "Cancel"
        sendString = "Send"
        emailTextField.placeholder = "Recipient"
        subjectTextField.placeholder = "Subject"
        noRecipientTitle = "You have not filled in the recipient!"
        noRecipientText = "Fill in the recipients of the message and try again."
        conceptTitle = "Draft"
        conceptText = "Do you want to discard the message?"
        conceptCancel = "Delete draft"
        incompleteTitle = "Incomplete message!"
        incompleteText = "Do you want to send the message without a subject or body text?"
    }
}
