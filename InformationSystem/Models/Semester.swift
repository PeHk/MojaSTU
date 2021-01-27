//
//  Semester.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 18/01/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation

class Semester {
    static let sharedInstance = Semester()
    
    var arrayOfSemesters = [Semester]()
    var actualSemester = String()
    var name = String()
    var id = String()
    var years = String()
    var studiesId = String()
    
    init(){}
    
    init(name: String, id: String, years: String) {
        self.id = id
        self.name = name
        self.years = years
    }
    
    func setStudiesId(id: String) {
        self.studiesId = id
    }
}
