//
//  EIndexViewController+Language.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 28/01/2021.
//  Copyright © 2021 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension EIndexViewController {
    override func changeLanguageToSlovak(_ notification: Notification) {
        super.changeLanguageToSlovak(notification)
        mainURL = mainURL.replacingOccurrences(of: "lang=en", with: "lang=sk")
        mainMarksURL = mainMarksURL.replacingOccurrences(of: "lang=en", with: "lang=sk")
        eIndexLabel.text = "Štúdium"
        subjectLabel.text = "Predmety"
        placesLabel.text = "Miesta odovzdania"
        testsLabel.text = "Testy a skúšanie"
        errorTitle = "Nastala chyba, skontrolujte si internetové pripojenie alebo prihlasovacie údaje!"
        cancelString = "Zrušiť"
        errorMessageFirst = "Počet pokusov na pripojenie: "
        errorMessageLast = "Tlačidlom zrušiť zavriete aplikáciu!"
        loadingString = "Načítavam..."
        blockRefresh = "Aktualizácia blokovaná"
        blockRefreshString = "Aktualizácia je možná len raz za 10 sekúnd!"
        startTimer()
        
        DispatchQueue.global().async {
            self.getSubjectTable(url: self.mainURL, urlForMarks: self.mainMarksURL)
            self.arraySemester = Semester.sharedInstance.arrayOfSemesters
            self.arraySubjects = EIndexSubject.sharedInstance.arrayOfSubjects
            self.actualSemester = Semester.sharedInstance.actualSemester
           
            DispatchQueue.main.async {
                self.picker.reloadAllComponents()
                self.tableView.reloadSections([0], with: UITableView.RowAnimation.automatic)
                self.tableView.isUserInteractionEnabled = true
                self.semesterLabel.text = self.selectedSemester
            }
        }

    }
    
    override func changeLanguageToEnglish(_ notification: Notification) {
        super.changeLanguageToEnglish(notification)
        mainURL = mainURL.replacingOccurrences(of: "lang=sk", with: "lang=en")
        mainMarksURL = mainMarksURL.replacingOccurrences(of: "lang=sk", with: "lang=en")
        eIndexLabel.text = "Study"
        subjectLabel.text = "Subjects"
        placesLabel.text = "Coursework submissions"
        testsLabel.text = "Tests and examinations"
        errorTitle = "An error occurred, check your internet connection or login details!"
        cancelString = "Cancel"
        errorMessageFirst = "Connection attempts: "
        errorMessageLast = "Tap Cancel to close the application!"
        loadingString = "Refreshing..."
        blockRefresh = "Update blocked"
        blockRefreshString = "The update is only possible once every 10 seconds!"
        startTimer()
        
        DispatchQueue.global().async {
            self.getSubjectTable(url: self.mainURL, urlForMarks: self.mainMarksURL)
            self.arraySemester = Semester.sharedInstance.arrayOfSemesters
            self.arraySubjects = EIndexSubject.sharedInstance.arrayOfSubjects
            self.actualSemester = Semester.sharedInstance.actualSemester

            DispatchQueue.main.async {
                self.picker.reloadAllComponents()
                self.tableView.reloadSections([0], with: UITableView.RowAnimation.automatic)
                self.tableView.isUserInteractionEnabled = true
                self.semesterLabel.text = self.selectedSemester
            }
        }
    }
}
