//
//  Subject.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 22/11/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import Foundation

class TimeTableSubject {
    var nameOfSubject = String()
    var nameOfTeacher = String()
    var timeOfStart = String()
    var timeOfEnd = String()
    var isSeminar = Bool()
    var room = String()
    var note = String()
    
    init(nameOfSubject: String, nameOfTeacher: String, timeOfStart: String, timeOfEnd: String, isSeminar: Bool, room: String) {
        self.nameOfSubject = nameOfSubject
        self.nameOfTeacher = nameOfTeacher
        self.timeOfStart = timeOfStart
        self.timeOfEnd = timeOfEnd
        self.isSeminar = isSeminar
        self.room = room
    }
}
