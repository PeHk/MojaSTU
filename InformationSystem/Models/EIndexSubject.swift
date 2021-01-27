//
//  EIndexSubject.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 18/01/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

class EIndexSubject {
    
    static let sharedInstance = EIndexSubject()
    
    var arrayOfSubjects = [EIndexSubject]()
    var subjectName = String()
    var subjectID = Int()
    var subjectMark = String()
    var subjectHTML = String()
    var sylabus = String()
    var files = String()
    var tests = String()
    var sheets = String()
    var presence = [UIColor]()
    var seminarPresence = [UIColor]()
    
    init(subjectName: String, sylabus: String, files: String, tests: String, sheets: String, seminarPresence: [UIColor]) {
        self.subjectName = subjectName
        self.sylabus = sylabus
        self.files = files
        self.tests = tests
        self.sheets = sheets
        self.seminarPresence = seminarPresence
    }
    
    init(){}
    
    init(subjectID: Int) {
        self.subjectID = subjectID
    }
    
    init(subjectMark: String) {
        self.subjectMark = subjectMark
    }
}
