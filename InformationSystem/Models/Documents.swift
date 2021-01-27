//
//  Documents.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 06/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation

class Documents {
    
    static let sharedInstance = Documents()
    
    var arrayOfDocuments = [EIndexSubject]()
    var subjectName = String()
    var subjectID = Int()
    var subjectMark = String()
    var subjectHTML = String()
    var sylabus = String()
    var files = String()
    var tests = String()
    var sheets = String()
    
    init(subjectName: String, sylabus: String, files: String, tests: String, sheets: String) {
        self.subjectName = subjectName
        self.sylabus = sylabus
        self.files = files
        self.tests = tests
        self.sheets = sheets
    }
    
    init(){}
    
    init(subjectID: Int) {
        self.subjectID = subjectID
    }
    
    init(subjectMark: String) {
        self.subjectMark = subjectMark
    }
    
    func getName() -> String {
        return self.subjectName
    }
    
    func setMark(mark: String) {
        self.subjectMark = mark
    }
    
    func getMark() -> String {
        return self.subjectMark
    }
}

