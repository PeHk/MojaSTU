//
//  AttachmentViewController+Language.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 29/01/2021.
//  Copyright © 2021 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension AttachmentViewController {
    override func changeLanguageToSlovak(_ notification: Notification) {
        super.changeLanguageToSlovak(notification)
        downloadLabel.text = "Sťahujem..."
        notFoundTitle = "Dokument nebol nájdený"
        notFoundText = "Nastala chyba pri vyhľadávaní dokumentu!"
        errorTitle = "Niečo sa pokazilo!"
        errorText = "Prosím skúste znova!"
        
    }
    
    override func changeLanguageToEnglish(_ notification: Notification) {
        super.changeLanguageToEnglish(notification)
        downloadLabel.text = "Downloading..."
        notFoundTitle = "Document not found"
        notFoundText = "An error occurred while searching for the document!"
        errorTitle = "Something went wrong!"
        errorText = "Please try again!"
    }
}
