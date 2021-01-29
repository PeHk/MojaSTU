//
//  EIndexDetailViewController+Language.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 29/01/2021.
//  Copyright © 2021 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension EIndexDetailViewController {
    override func changeLanguageToSlovak(_ notification: Notification) {
        super.changeLanguageToSlovak(notification)
        noPointsView.messageText = "V predmete nemáš žiadne bodové hárky"
        noPointsView.titleText = "Žiadne body"
        mainTableName.text = "Bodové hárky"
        excerciseLabel.text = "Cvičenia: "
        seminarLabel.text = "Prednášky: "
        seminarsText = "Cvičenia: "
        errorTitle = "Nastala chyba, skontrolujte si internetové pripojenie alebo prihlasovacie údaje!"
        cancelString = "Zrušiť"
        errorMessageFirst = "Počet pokusov na pripojenie: "
        errorMessageLast = "Tlačidlom zrušiť zavriete aplikáciu!"
    }

    override func changeLanguageToEnglish(_ notification: Notification) {
        super.changeLanguageToEnglish(notification)
        noPointsView.messageText = "You have no score sheets in the subject"
        noPointsView.titleText = "No points"
        mainTableName.text = "Sheets"
        excerciseLabel.text = "Seminars: "
        seminarLabel.text = "Lectures: "
        seminarsText = "Seminars: "
        errorTitle = "An error occurred, check your internet connection or login details!"
        cancelString = "Cancel"
        errorMessageFirst = "Connection attempts: "
        errorMessageLast = "Tap Cancel to close the application!"
    }
}
