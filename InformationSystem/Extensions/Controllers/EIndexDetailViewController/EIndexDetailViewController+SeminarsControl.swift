//
//  SeminarsControl.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 05/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

class SeminarsControl : UIStackView {
    
    var count = 1
    var color = UIColor.gray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
     
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addCircle(color: UIColor, text: String) {
        let view = UIView()
        
        let weekNum: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = text
            label.font = UIFont.systemFont(ofSize: 9, weight: .light)
            return label
        }()
        
        
        view.backgroundColor = color
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 17.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 17.0).isActive = true
        
        view.layer.cornerRadius = 17 / 2
        view.layer.masksToBounds = true
        
        view.addSubview(weekNum)
        
        weekNum.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        weekNum.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        addArrangedSubview(view)
    }
}
