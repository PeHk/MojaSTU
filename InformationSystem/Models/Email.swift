//
//  Email.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 22/01/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation

class Email {
    static let sharedInstance = Email()
    
    var name = String()
    var date = String()
    var subject = String()
    var time = String()
    var httpLink = String()
    var unread = false
    var textOfEmail = String()
    var serialCode = String()
    var old_eid = String()
    var old_fid = String()
    var eid = String()
    var fid = String()
    var attachment = false
    
    init(subject: String, name: String, date: String, time: String, link: String, unread: Bool, attachment: Bool) {
        self.subject = subject
        self.name = name
        self.date = date
        self.time = time
        self.httpLink = link
        self.unread = unread
        self.attachment = attachment
    }
    
    init() {
        
    }
    
    init(subject: String, name: String, textOfEmail: String, serialCode: String, old_eid: String, old_fid: String, fid: String, eid: String) {
        self.subject = subject
        self.name = name
        self.textOfEmail = textOfEmail
        self.serialCode = serialCode
        self.eid = eid
        self.fid = fid
        self.old_fid = old_fid
        self.old_eid = old_eid
    }
    
    init(serialCode: String) {
        self.serialCode = serialCode
    }
    
}
