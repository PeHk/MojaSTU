//
//  AttachmentTableViewCell.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 30/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

class MailboxCell: UITableViewCell {
    
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let isDarkMode = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        if isDarkMode {
            backgroundColor = .black
            nameLabel.textColor = .white
            count.textColor = .white
        }
        else {
            backgroundColor = .white
            nameLabel.textColor = .black
            count.textColor = .black
        }
    }
    
}
