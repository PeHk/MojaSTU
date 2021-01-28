//
//  TimeTableController+Language.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 28/01/2021.
//  Copyright © 2021 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension TimeTableController {
    override func changeLanguageToSlovak(_ notification: Notification) {
        super.changeLanguageToSlovak(notification)
        nameOfDays = ["nil", "Nedeľa", "Pondelok", "Utorok", "Streda", "Štvrtok", "Piatok", "Sobota"]
        messageText = "Na dnešný deň nemáš žiadne rozvrhové akcie"
        titleText = "Žiadny rozvrh"
        language = "sk"
        importantNoticeTitle = "Dôležité upozornenie"
        importantNoticeMessage = "Notifikácie je možné prijímať iba, ak je aplikácia v stave \"bežiaca na pozadí\" (viď obrázok) - nie je ukončená. Žiaľ, je to jediný možný spôsob, nakoľko sa nejedná o oficálnu aplikáciu pre AIS.\n Svoju voľbu môžete jednoducho zmeniť aj v nastaveniach aplikácie."
        importantSuccess = "Zapnúť notifikácie"
        importantCanceled = "Vypnúť notifikácie"
        nameDayURL = "https://is.stuba.sk/auth/?lang=sk"
        nameDayString = "Meniny má: "
        errorTitle = "Nastala chyba, skontrolujte si internetové pripojenie alebo prihlasovacie údaje!"
        cancelString = "Zrušiť"
        errorMessageFirst = "Počet pokusov na pripojenie: "
        errorMessageLast = "Tlačidlom zrušiť zavriete aplikáciu!"
        noSubjectsView.messageText = messageText
        noSubjectsView.titleLabel.text = titleText
        timeTableDay.text = nameOfDays[indexOfDay]
    }
    
    override func changeLanguageToEnglish(_ notification: Notification) {
        super.changeLanguageToEnglish(notification)
        nameOfDays = ["nil", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        messageText = "You have no schedule events for today"
        titleText = "No schedule"
        language = "en"
        importantNoticeTitle = "Important notice"
        importantNoticeMessage = "Notifications can only be received if the application is in the \"running\" state (see image) - it is not closed. Unfortunately, this is the only possible way as it is not an official application for AIS. \n Your you can also easily change this option in the app settings."
        importantSuccess = "Turn on"
        importantCanceled = "Turn off"
        nameDayURL = "https://is.stuba.sk/auth/?lang=sk"
        nameDayString = "Nameday has: "
        errorTitle = "An error occurred, check your internet connection or login details!"
        cancelString = "Cancel"
        errorMessageFirst = "Connection attempts: "
        errorMessageLast = "Tap Cancel to close the application!"
        noSubjectsView.messageText = messageText
        noSubjectsView.titleLabel.text = titleText
        timeTableDay.text = nameOfDays[indexOfDay]
    }
}
