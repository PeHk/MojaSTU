//
//  PersonalDataTableViewCell.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 12/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

class PersonalDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    func checkMode() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        if isDarkMode {
            backgroundColor = .black
            title.textColor = .white
            subtitle.textColor = .white
        }
        else {
            backgroundColor = .white
            title.textColor = .black
            subtitle.textColor = .black
        }
    }
}
