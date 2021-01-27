//
//  Mailbox.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 04/04/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation

class Mailbox {
    var name = String()
    var id = String()
    var count = String()
    
    init(name: String, id: String, count: String) {
        self.name = name
        self.id = id
        self.count = count
    }
}
