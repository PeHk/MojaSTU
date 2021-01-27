//
//  TimeTableViewCell.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 01/01/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

class TimeTableViewCell: UITableViewCell {
    @IBOutlet weak var nameSubject: UILabel! {
        didSet {
            nameSubject.font = UIFont.preferredFont(forTextStyle: .headline)
            nameSubject.adjustsFontForContentSizeCategory = true
        }
    }
    @IBOutlet weak var nameTeacher: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var note: UILabel!
    
    func changeMode(isDarkMode: Bool, isSeminar: Bool) {
        if isSeminar {
            if isDarkMode {
                backgroundColor = UIColor(hex: "#2b9dbaff")
                nameSubject.textColor = UIColor.white
                startTime.textColor = UIColor.white
                endTime.textColor = UIColor.white
                roomName.textColor = UIColor.white
                nameTeacher.textColor = UIColor.white
                note.textColor = UIColor.white
            }
            else {
                backgroundColor = UIColor(hex: "#e0ffffff")
                nameSubject.textColor = UIColor.black
                startTime.textColor = UIColor.black
                endTime.textColor = UIColor.black
                roomName.textColor = UIColor.darkGray
                nameTeacher.textColor = UIColor.darkGray
                note.textColor = UIColor.darkGray
            }
        }
        // prednaska
        else {
            if isDarkMode {
                backgroundColor = UIColor(hex: "#016191ff")
                nameSubject.textColor = UIColor.white
                startTime.textColor = UIColor.white
                endTime.textColor = UIColor.white
                roomName.textColor = UIColor.white
                nameTeacher.textColor = UIColor.white
                note.textColor = UIColor.white
            }
            else {
                backgroundColor = UIColor(hex: "#9ed1e6ff")
                nameSubject.textColor = UIColor.black
                startTime.textColor = UIColor.black
                endTime.textColor = UIColor.black
                roomName.textColor = UIColor.darkGray
                nameTeacher.textColor = UIColor.darkGray
                note.textColor = UIColor.darkGray
            }
        }
    }
}
