//
//  EIndexViewController+PickerDelegate.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 19/01/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for picker datasource and delegate.

import Foundation
import UIKit

extension EIndexViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if arraySemester.count == 1 {
            semesterLabel.isUserInteractionEnabled = false
            dropDownImage.isHidden = true
        }
        return arraySemester.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arraySemester[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        semesterLabel.text = arraySemester[row].name
        actualIDOfSemester = arraySemester[row].id
        actualIDOfStudy = arraySemester[row].studiesId
        
        if arraySemester[row].name.trimmingCharacters(in: .whitespacesAndNewlines) == arraySemester.last?.name.trimmingCharacters(in: .whitespacesAndNewlines) {
            testsView.isHidden = false
            borderView.isHidden = false
            tableHeaderView.frame.size.height = 283
        }
        else {
            testsView.isHidden = true
            borderView.isHidden = true
            tableHeaderView.frame.size.height = 203
        }
        
        if !Studies.sharedInstance.arrayOfStudies.isEmpty {
            mainURL = "https://is.stuba.sk/auth/student/list.pl?studium=\(arraySemester[row].studiesId);obdobi=\(arraySemester[row].id);lang=sk"
            mainMarksURL = "https://is.stuba.sk/auth/student/pruchod_studiem.pl?studium=\(arraySemester[row].studiesId);obdobi=\(arraySemester[row].id);lang=sk"
        }
        else {
            mainURL = "https://is.stuba.sk/auth/student/list.pl?obdobi=\(arraySemester[row].id);lang=sk"
            mainMarksURL = "https://is.stuba.sk/auth/student/pruchod_studiem.pl?obdobi=\(arraySemester[row].id);lang=sk"
        }
        
        arraySubjects = nil
        reloadFlag = true
        tableView.reloadData()
        view.endEditing(true)
        
        DispatchQueue.global().async {
            self.getSubjectTable(url: self.mainURL, urlForMarks: self.mainMarksURL)
            self.arraySubjects = EIndexSubject.sharedInstance.arrayOfSubjects
            DispatchQueue.main.async {
                self.startTimer()
                self.tableView.reloadSections([0], with: .automatic)
            }
        }
    }
    
    func createPickerView() {
        picker.delegate = self
        picker.dataSource = self
    }
}
