//
//  PlacesDetailCell.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 07/04/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

class PlacesDetailCell: UITableViewCell {
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var openView: UIView! {
        didSet {
            openView.layer.cornerRadius = openView.frame.height / 2
        }
    }
    @IBOutlet weak var bellView: UIImageView! {
        didSet {
            bellView.isHidden = true
        }
    }
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeMode()
        isSkeletonable = true
        [nameLabel, subjectLabel, openView, date, time, teacherLabel, pointsLabel].forEach {
            $0?.clipsToBounds = true
            $0?.showAnimatedGradientSkeleton()
        }
    }
    
    func hideAnimation() {
        [nameLabel, subjectLabel, openView, date, time, teacherLabel, pointsLabel].forEach {
            $0?.hideSkeleton()
        }
    }
    
    func changeMode() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        if isDarkMode {
            allView.backgroundColor = .black
            nameLabel.textColor = .white
            teacherLabel.textColor = .white
            time.textColor = .white
            date.textColor = .white
            subjectLabel.textColor = .white
            pointsLabel.textColor = .white
        }
        else {
            allView.backgroundColor = .white
            nameLabel.textColor = .black
            teacherLabel.textColor = .darkGray
            time.textColor = .black
            date.textColor = .black
            subjectLabel.textColor = .darkGray
            pointsLabel.textColor = .black
        }
    }
}
    
