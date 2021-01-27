//
//  People.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 21/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation

class Person {
    var name = String()
    var id = String()
    var study = String()
    var acronym = String()
    
    init(name: String, id: String, study: String, acronym: String) {
        self.name = name
        self.id = id
        self.study = study
        self.acronym = acronym
    }
}
