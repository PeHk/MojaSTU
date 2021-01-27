//
//  EIndexViewController+PickerView.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 01/04/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for creating pickerView

import Foundation
import UIKit
import SkeletonView
import Firebase

extension EIndexViewController {

    func setSemesterLabel() {
        DispatchQueue.main.async {
            self.stackViewSemester.hideSkeleton()
            self.semesterLabel.text = self.actualSemester
            self.picker.selectRow(self.arraySemester.count - 1, inComponent: 0, animated: false)
            Analytics.logEvent("semestersLoaded", parameters: nil)
        }
    }
    
    func setSemesterLabelWithoutRequest(){
        stackViewSemester.hideSkeleton()
        semesterLabel.text = actualSemester
        picker.selectRow(arraySemester.count - 1, inComponent: 0, animated: false)
    }
    
    @objc func displayPickerView(){
        if  textField == nil {
            self.textField = UITextField(frame:.zero)
            textField.inputView = self.picker
            self.view.addSubview(textField)
        }
        textField.becomeFirstResponder()
    }
}
