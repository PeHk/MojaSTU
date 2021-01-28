//
//  PlacesDownloadViewController+Language.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 28/01/2021.
//  Copyright © 2021 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension PlacesDownloadViewController {
    override func changeLanguageToSlovak(_ notification: Notification) {
        super.changeLanguageToSlovak(notification)
        staticName.text = "Názov:"
        staticSubject.text = "Predmet:"
        staticEndDate.text = "Dátum uzavretia:"
        staticUploadDate.text = "Dátum odovzdania:"
        staticSuccessLabel.text = "Súbory boli riadne odovzdané"
        pointsLabel.text = "Body:"
        controllerLabel.text = "Miesto odovzdania"
        tableLabel.text = "Odovzdané súbory"
        errorTitle = "Nastala chyba, skontrolujte si internetové pripojenie alebo prihlasovacie údaje!"
        cancelString = "Zrušiť"
        errorMessageFirst = "Počet pokusov na pripojenie: "
        errorMessageLast = "Tlačidlom zrušiť zavriete aplikáciu!"
        downloadLabel.text = "Sťahujem..."
    }
    
    override func changeLanguageToEnglish(_ notification: Notification) {
        super.changeLanguageToEnglish(notification)
        staticName.text = "Name:"
        staticSubject.text = "Subject:"
        staticEndDate.text = "Closing date:"
        staticUploadDate.text = "Upload date:"
        staticSuccessLabel.text = "The files have been uploaded properly"
        pointsLabel.text = "Points:"
        controllerLabel.text = "Submission place"
        tableLabel.text = "Uploaded files"
        errorTitle = "An error occurred, check your internet connection or login details!"
        cancelString = "Cancel"
        errorMessageFirst = "Connection attempts: "
        errorMessageLast = "Tap Cancel to close the application!"
        downloadLabel.text = "Downloading..."
    }
}

