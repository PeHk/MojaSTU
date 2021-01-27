//
//  Date+NumberOfDay.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 21/12/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import Foundation

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

