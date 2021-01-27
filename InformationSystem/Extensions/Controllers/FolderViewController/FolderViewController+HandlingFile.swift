//
//  FolderViewController+HandlingFile.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 31/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for downloading files.

import Foundation
import UIKit

extension FolderViewController {
//    MARK: Download file
    func downloadFile(url: String) {
        network.postFile(url: url, completion: {result, statusCode, success in
            if success {
                if result != nil {
                    if result!.isFileURL {
                        self.pdfURL = result!
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
    
//    MARK: Show PDF
    func showPdf() {
        downloadView.isHidden = true
        indicator.stopAnimating()
        let storyboard = UIStoryboard(name: "Documents", bundle: nil);
        let pdfViewController = storyboard.instantiateViewController(withIdentifier: "PDFController") as! PDFViewController
        pdfViewController.pdfURL = self.pdfURL
        self.navigationController?.pushViewController(pdfViewController, animated: true)
    }
}
