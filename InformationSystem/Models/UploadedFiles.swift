//
//  UploadedFiles.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 09/06/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation

class UploadedFiles {
    var name = String()
    var link = String()
    var author = String()
    
    init(name: String, link: String, author: String) {
        self.name = name
        self.link = link
        self.author = author
    }
}
