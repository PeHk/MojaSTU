//
//  EIndexDetailViewRowCell.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 05/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

class EIndexDetailViewSectionCell: UITableViewCell {

    @IBOutlet weak var name: UILabel! {
        didSet {
            name.adjustsFontSizeToFitWidth = true
        }
    }
    
    func changeMode() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        if isDarkMode {
            contentView.backgroundColor = .darkGray
            name.textColor = .white
        }
        else {
            contentView.backgroundColor = UIColor(hex: "#e6e6e6ff")
            name.textColor = .black
        }
    }
}
