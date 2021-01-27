//
//  UIViewController+Review.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 17/04/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import StoreKit

class Review {
    func incrementOpen() {
        guard var openCount = UserDefaults.standard.value(forKey: "reviewOpenCount") as? Int else {
            UserDefaults.standard.set(1, forKey: "reviewOpenCount")
            return
        }
        
        switch openCount {
        case 500,1000,1500:
            SKStoreReviewController.requestReview()
        case _ where openCount%1000 == 0 :
            SKStoreReviewController.requestReview()
        default:
            openCount += 1
            UserDefaults.standard.set(openCount, forKey: "reviewOpenCount")
            print("App run count is : \(openCount)")
            break;
        }
    }
}

