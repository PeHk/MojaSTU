//
//  JSONParser.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 21/11/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import Foundation
import SwiftyJSON

class JSONParser: NSObject {
    
    var HTMLstring = String()
    var daySubjects = [TimeTableSubject]()
    var sortedDaySubjects = [TimeTableSubject]()
    var teacherName = String()
    var room = String()
    
    func parseTimeTable(dayOfWeek: String) {
        
        sortedDaySubjects = [TimeTableSubject]()
        daySubjects = [TimeTableSubject]()
        
        if let dataFromString = HTMLstring.data(using: .utf8, allowLossyConversion: false) {
            if let json = try? JSON(data: dataFromString) {
                
                for item in json["periodicLessons"].arrayValue {
                    if (item["dayOfWeek"].stringValue) == dayOfWeek {
                        
                        for name in item["teachers"].arrayValue {
                            teacherName = name["shortName"].stringValue
                        }
                        
                        let note = item["note"].stringValue
                        
                        var isSeminar = false
                        if item["isSeminar"].stringValue == "true" {
                            isSeminar = true
                        }
                        
                        let subject = TimeTableSubject(nameOfSubject: item["courseName"].stringValue, nameOfTeacher: teacherName, timeOfStart: item["startTime"].stringValue, timeOfEnd: item["endTime"].stringValue, isSeminar: isSeminar, room: item["room"].stringValue)
                        if !note.isEmpty {
                            subject.note = note
                        }
                        daySubjects.append(subject)
                    }
                }
            }
        }
        sortedDaySubjects = daySubjects.sorted(by: { $0.timeOfStart < $1.timeOfStart })
    }
    
    func parsePeople(jsonString: String) -> Array<Person>{
        var array = [Person]()
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            if let json = try? JSON(data: dataFromString) {
                for (_,subJson):(String, JSON) in json["data"] {
                    let name = subJson[0].stringValue
                    let id = subJson[1].stringValue
                    let study = subJson[3].stringValue
                    let acronym = name.getAcronym(name: name)
                    let people = Person(name: name, id: id, study: study, acronym: acronym)
                    array.append(people)
                }
            }
        }
        return array
    }
}
