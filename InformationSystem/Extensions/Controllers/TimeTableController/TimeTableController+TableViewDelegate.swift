//
//  TimeTableController+TableView.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 01/01/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for datasource and delegate of table

import Foundation
import UIKit

extension TimeTableController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daySubjects.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeTableCell", for: indexPath) as! TimeTableViewCell
        let subject = daySubjects[indexPath.row]
        let isDarkMode = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        cell.changeMode(isDarkMode: isDarkMode, isSeminar: subject.isSeminar)
        
        cell.nameSubject?.text = subject.nameOfSubject
        cell.nameTeacher?.text = subject.nameOfTeacher
        cell.endTime?.text = subject.timeOfEnd
        cell.startTime?.text = subject.timeOfStart
        cell.roomName?.text = stringparser.prefixWithVal(value: ")", string: subject.room)
        
        if !subject.note.isEmpty {
            cell.note?.text = subject.note
            cell.note.isHidden = false
        }
        else {
            cell.note.isHidden = true
        }
        
        return cell
    }
}
