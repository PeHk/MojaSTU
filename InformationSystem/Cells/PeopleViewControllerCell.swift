//
//  PeopleViewControllerCell.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 21/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

class PersonViewControllerCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoView: UIView! {
        didSet {
            photoView.layer.cornerRadius = (photoView.frame.height) / 2
            photoView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var acronymLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
