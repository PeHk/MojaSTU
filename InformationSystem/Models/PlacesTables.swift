//
//  PlacesTables.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 07/04/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation

class PlacesTables {
    var name = String()
    var array = [Places]()
    var reminders = Bool()
    
    init(name: String, array: Array<Places>, reminders: Bool) {
        self.name = name
        self.array = array
        self.reminders = reminders
    }
}
