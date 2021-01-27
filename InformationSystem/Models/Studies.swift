//
//  Studies.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 21/01/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation

class Studies {
    static let sharedInstance = Studies()
    var arrayOfStudies = [Studies]()
    var id = String()
    var name = String()
    var countOfSemesters = Int()
    
    init(name: String, id: String, count: Int) {
        self.id = id
        self.name = name
        self.countOfSemesters = count
    }
    
    init(){
        
    }
}
