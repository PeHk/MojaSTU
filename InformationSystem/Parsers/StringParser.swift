//
//  StringParser.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 23/12/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import Foundation

class StringParser: NSObject {
    
    func prefixWithVal(value: String, string: String) -> String {
        var prefix = String()
        if let index = (string.range(of: value)?.upperBound)
        {
            prefix = String(string.prefix(upTo: index))
        }
        
        return prefix
    }
    
    func prefixWithoutVal(value: String, string: String) -> String {
        var prefix = String()
        if let index = (string.range(of: value)?.lowerBound)
        {
            prefix = String(string.prefix(upTo: index))
        }
        
        return prefix
    }
    
    func suffixWithVal(value: String, string: String) -> String {
        var suffix = String()
        if let index = (string.range(of: value)?.lowerBound)
        {
            suffix = String(string.suffix(from: index))
        }
        
        return suffix
    }
    
    func suffixWithoutVal(value: String, string: String) -> String {
        var suffix = String()
        if let index = (string.range(of: value)?.upperBound)
        {
            suffix = String(string.suffix(from: index))
        }
        
        return suffix
    }
    
    func getDate(string: String) -> (String, String){
        var finalDate = String()
        var tmp = String()
        var time = String()
        
        finalDate = prefixWithoutVal(value: " ", string: string)
        tmp = suffixWithoutVal(value: " ", string: string)
        
        finalDate = finalDate + prefixWithoutVal(value: " ", string: tmp)
        tmp = suffixWithoutVal(value: " ", string: tmp)
        
        finalDate = finalDate + prefixWithoutVal(value: " ", string: tmp)
        tmp = suffixWithoutVal(value: " ", string: tmp)
        
        time = tmp
        
        return (finalDate, time)
    }
}
