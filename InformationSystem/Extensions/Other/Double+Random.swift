//
//  Double+Random.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 14/11/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation


public extension Double {

    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }

    /// Random double between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random double point number between 0 and n max
    static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}
