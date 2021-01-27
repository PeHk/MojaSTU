//
//  EmailTableViewCell.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 28/12/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import UIKit
import SkeletonView

class EmailTableViewCell: UITableViewCell {
    @IBOutlet weak var timeOfEmail: UILabel!
    @IBOutlet weak var dateOfEmail: UILabel!
    @IBOutlet weak var senderOfEmail: UILabel!
    @IBOutlet weak var attachmentView: UIImageView!
    @IBOutlet weak var unreadMarkView: UIView! {
        didSet {
            unreadMarkView.layer.cornerRadius = (unreadMarkView.frame.height) / 2
        }
    }
    @IBOutlet weak var subjectOfEmail: UILabel! {
        didSet {
            subjectOfEmail.font = UIFont.preferredFont(forTextStyle: .headline)
            subjectOfEmail.adjustsFontForContentSizeCategory = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkMode()
        isSkeletonable = true
        unreadMarkView.isHidden = true
        [timeOfEmail, subjectOfEmail, dateOfEmail, senderOfEmail].forEach {
            $0?.clipsToBounds = true
            $0?.showAnimatedGradientSkeleton()
        }
    }
    
    func hideAnimation() {
        [timeOfEmail, subjectOfEmail, dateOfEmail, senderOfEmail].forEach {
            $0?.hideSkeleton()
        }
    }
    
    func checkMode() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        if isDarkMode {
            backgroundColor = .black
            subjectOfEmail.textColor = .white
            senderOfEmail.textColor = .white
            timeOfEmail.textColor = .white
            dateOfEmail.textColor = .white
        }
        else {
            backgroundColor = .white
            subjectOfEmail.textColor = .black
            senderOfEmail.textColor = .black
            timeOfEmail.textColor = .black
            dateOfEmail.textColor = .black
        }
    }
}
