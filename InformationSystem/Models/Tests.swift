//
//  Tests.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 03/06/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation

class Tests {
    var testName = String()
    var allPoints = String()
    var myPoints = String()
    var pointsToAdd : String? = nil
    
    let stringparser: StringParser = StringParser()
    
    init(testName: String, allPoints: String, remainingPoints: String) {
        self.testName = testName
        self.allPoints = allPoints
        self.myPoints = remainingPoints
        
        getPointsToAdd()
        
        self.myPoints = self.myPoints.trimmingCharacters(in: .whitespacesAndNewlines)
        self.allPoints = self.allPoints.trimmingCharacters(in: .whitespacesAndNewlines)
        if self.allPoints != "" {
            self.allPoints = "/ " + self.allPoints
        }
    }
    
    func getPointsToAdd() {
        if myPoints.contains("(") {
            self.pointsToAdd = stringparser.suffixWithVal(value: "(", string: myPoints)
            self.myPoints = stringparser.prefixWithoutVal(value: "(", string: myPoints)
            self.pointsToAdd = self.pointsToAdd?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}
