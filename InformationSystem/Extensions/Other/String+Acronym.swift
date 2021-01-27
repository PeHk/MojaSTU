//
//  String+Acronym.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 21/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation

extension String {
    func getAcronym(name: String) -> String {
        let stringInputArr = name.components(separatedBy: " ")
        var acronym = ""

        for string in stringInputArr {
            acronym = acronym + String(string.first!)
        }
        
        return String(acronym.prefix(2))
    }
}
