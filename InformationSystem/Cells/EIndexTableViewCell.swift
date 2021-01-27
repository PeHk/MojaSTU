//
//  EIndexTableViewCell.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 28/12/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

class EIndexTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var evaluationLabel: UILabel!
    @IBOutlet weak var evaluationView: UIView! {
        didSet {
            evaluationView.layer.cornerRadius = (evaluationView.frame.height) / 2
            evaluationView.layer.masksToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isSkeletonable = true
        changeMode()
        [nameLabel, evaluationView].forEach {
            $0?.clipsToBounds = true
            $0?.showAnimatedGradientSkeleton()
        }
    }
    
    func hideAnimation() {
        [nameLabel, evaluationView].forEach {
            $0?.hideSkeleton()
        }
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
