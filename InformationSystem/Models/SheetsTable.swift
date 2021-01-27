//
//  SheetsTable.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 04/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation

class SheetsTable {
    var name = String()
    var dictionary = [KeyValue]()
    var opened = false
    
    init(name: String, dictionary: [KeyValue]) {
        self.name = name
        self.dictionary = dictionary
    }
}
