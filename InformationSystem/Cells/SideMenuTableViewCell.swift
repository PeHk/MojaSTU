//
//  SideMenuTableViewCell.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 26/12/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

class SideMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellName: UILabel!
    
    func changeMode() {
        super.awakeFromNib()
        let isDarkMode = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        if isDarkMode {
            backgroundColor = .black
            cellName.textColor = .white
        }
        else {
            backgroundColor = .white
            cellName.textColor = .black
        }
    }
}
