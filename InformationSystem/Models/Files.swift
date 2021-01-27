//
//  Files.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 07/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
import Foundation

class Files {
    
    static let sharedInstance = Files()
    
    var arrayOfFiles = [Files]()
    var arrayOfFolderFiles = [Files]()
    var fileName = String()
    var fileDownload = String()
    var folder = Bool()
    var isPDF = Bool()
    
    init(fileName: String, fileDownload: String, folder: Bool, isPDF: Bool) {
        self.fileName = fileName
        self.fileDownload = fileDownload
        self.folder = folder
        self.isPDF = isPDF
    }
    
    init() {}
    
}
