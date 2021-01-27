//
//  PlacesDownloadCell.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 09/06/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

class PlacesDownloadCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        if isDarkMode {
            backgroundColor = .black
            nameLabel.textColor = .white
        }
        else {
            backgroundColor = .white
            nameLabel.textColor = .black
        }
    }
    
}
