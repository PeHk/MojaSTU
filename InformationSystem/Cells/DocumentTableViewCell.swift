//
//  DocumentTableViewCell.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 28/12/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

class DocumentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeMode()
        isSkeletonable = true
        nameLabel.clipsToBounds = true
        nameLabel.showAnimatedGradientSkeleton()
    }
    
    func hideAnimation() {
        nameLabel.hideSkeleton()
    }
    
    func changeMode() {
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
