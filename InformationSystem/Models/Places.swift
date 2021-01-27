//
//  Places.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 07/04/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation

class Places {
    var name = String()
    var subject = String()
    var date = String()
    var time = String()
    var teacher = String()
    var detail = String()
    var isOpened : Bool?
    var points : String?
    
    init(name: String, subject: String, date: String, time: String, teacher: String, detail: String, isOpened: Bool?, points: String?) {
        self.name = name
        self.subject = subject
        self.date = date
        self.time = time
        self.teacher = teacher
        self.detail = detail
        self.isOpened = isOpened
        self.points = points
    }
}
