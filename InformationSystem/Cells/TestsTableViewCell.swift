//
//  TestsTableViewCell.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 03/06/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

class TestsTableViewCell: UITableViewCell {
    

    @IBOutlet weak var testNameLabel: UILabel!
    @IBOutlet weak var pointsToAdd: UILabel!
    @IBOutlet weak var allPoints: UILabel!
    @IBOutlet weak var myPoints: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeMode()
        isSkeletonable = true
        [testNameLabel, pointsToAdd, allPoints, myPoints].forEach {
            $0?.clipsToBounds = true
            $0?.showAnimatedGradientSkeleton()
        }
    }
    
    func hideAnimation() {
        [testNameLabel, pointsToAdd, allPoints, myPoints].forEach {
            $0?.hideSkeleton()
        }
    }
    
    func changeMode() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        if isDarkMode {
            backgroundColor = .black
            testNameLabel.textColor = .white
            allPoints.textColor = .white
        }
        else {
            backgroundColor = .white
            testNameLabel.textColor = .black
            allPoints.textColor = .black
        }
    }
}
