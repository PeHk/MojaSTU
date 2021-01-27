//
//  AttachmentViewController+DownloadFile.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 31/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for downloading files from server.

import Foundation

extension AttachmentViewController {
//    MARK: Downloading PDF
    func downloadFile(url: String, fileName: String) {
        urlsManager.postAttachment(url: url, fileName: fileName, completion: {result, statusCode, success in
            if success {
                if result != nil {
                    if result!.isFileURL {
                        self.fileURL = result!
                    }
                    else {
                        DispatchQueue.main.async {
                            self.showAlertWindow(title: "Niečo sa pokazilo!", message: "Prosím skúste znova!")
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.showAlertWindow(title: "Niečo sa pokazilo!", message: "Prosím skúste znova!")
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    self.showAlertWindow(title: "Niečo sa pokazilo!", message: "Prosím skúste znova!")
                }
            }
        })
    }
    
}
