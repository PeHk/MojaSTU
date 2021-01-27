//
//  DocumentDetailTableViewCell.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 06/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

class DocumentDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pdfView: UIImageView!
    @IBOutlet weak var fileName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeMode()
        fileName.showAnimatedGradientSkeleton()
    }
    
    func hideAnimation() {
        fileName.hideSkeleton()
    }
    
    func changeMode() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        if isDarkMode {
            backgroundColor = .black
            fileName.textColor = .white
        }
        else {
            backgroundColor = .white
            fileName.textColor = .black
        }
    }
}
