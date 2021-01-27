//
//  UIViewController+Logout.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 01/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

extension UIViewController {
    func resetDefaults() {
        KeychainWrapper.standard.removeAllKeys()
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        Semester.sharedInstance.actualSemester = ""
        EIndexSubject.sharedInstance.arrayOfSubjects.removeAll()
        Semester.sharedInstance.arrayOfSemesters.removeAll()
        Studies.sharedInstance.arrayOfStudies.removeAll()
        Documents.sharedInstance.arrayOfDocuments.removeAll()
    }
}
