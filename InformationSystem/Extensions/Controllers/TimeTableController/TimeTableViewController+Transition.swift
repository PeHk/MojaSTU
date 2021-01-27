//
//  File.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 28/12/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//
//  Extension for animations in table

import Foundation
import UIKit

extension TimeTableController {
//    MARK: Animation right
    func addAnimationToRight() {
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.fillMode = CAMediaTimingFillMode.forwards
        transition.duration = 0.5
        transition.subtype = CATransitionSubtype.fromRight
        self.tableView.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
    }
//    MARK: Animation left
    func addAnimationToLeft() {
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.fillMode = CAMediaTimingFillMode.forwards
        transition.duration = 0.5
        transition.subtype = CATransitionSubtype.fromLeft
        self.tableView.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
    }
//    MARK: Recognize gestures
    func addRecognizers() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(leftSwipe)
    }
//    MARK: Handle gesture
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .right:
                fetchPreviousDay()
            case .left:
                fetchNextDay()
            default:
                break
            }
        }
    }
}
