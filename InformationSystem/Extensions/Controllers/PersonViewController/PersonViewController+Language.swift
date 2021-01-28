//
//  PersonViewController+Language.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 28/01/2021.
//  Copyright © 2021 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension PersonViewController {
    override func changeLanguageToSlovak(_ notification: Notification) {
        super.changeLanguageToSlovak(notification)
        startSearchView.messageText = "Pre vyhľadanie človeka začni písať jeho meno"
        startSearchView.titleText = "Vyhľadávanie ľudí na STU"
        emptyStateView.messageText = "Vyhľadávaný používateľ neexistuje"
        emptyStateView.titleText = "Nikoho sme nenašli!"
        language = "sk"
        searchBar.placeholder = "Vyhľadať človeka"
        peopleLabel.text = "Ľudia na STU"
    }
    
    override func changeLanguageToEnglish(_ notification: Notification) {
        super.changeLanguageToEnglish(notification)
        startSearchView.messageText = "To search for a person, start typing his name"
        startSearchView.titleText = "Searching for people at STU"
        emptyStateView.messageText = "The user you are looking for does not exist"
        emptyStateView.titleText = "We didn't find anyone!"
        language = "en"
        searchBar.placeholder = "Search for a person"
        peopleLabel.text = "People at STU"
    }
}
