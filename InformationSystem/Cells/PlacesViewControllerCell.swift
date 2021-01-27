//
//  PlacesViewControllerCell.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 07/04/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

class PlacesViewControllerCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isSkeletonable = true
        [nameLabel].forEach {
            $0?.clipsToBounds = true
            $0?.showAnimatedGradientSkeleton()
        }
    }
    
    func hideAnimation() {
        [nameLabel].forEach {
            $0?.hideSkeleton()
        }
    }
}
