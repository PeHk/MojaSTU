//
//  DocumentDetailViewController+DownloadFile.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 31/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension handling download of file with opening a file.

import Foundation
import UIKit

extension DocumentDetailViewController {
//    MARK: Downloading PDF
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
//     MARK: Open PDF
    func showPdf() {
        downloadView.isHidden = true
        indicator.stopAnimating()
        
        let storyboard = UIStoryboard(name: "Documents", bundle: nil);
        let pdfViewController = storyboard.instantiateViewController(withIdentifier: "PDFController") as! PDFViewController
        pdfViewController.pdfURL = self.pdfURL
        self.navigationController?.pushViewController(pdfViewController, animated: true)
    }
    
    
}
