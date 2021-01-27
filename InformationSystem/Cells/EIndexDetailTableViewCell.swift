//
//  EIndexDetailTableViewCell.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 04/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

class EIndexDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel! {
        didSet {
            name.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var value: UILabel! {
        didSet {
            value.adjustsFontSizeToFitWidth = true
        }
    }
    
    func changeMode() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        if isDarkMode {
            name.textColor = .white
            value.textColor = .white
            backgroundColor = .gray
        }
        else {
            name.textColor = .black
            value.textColor = .black
            backgroundColor = .white
        }
    }
}
