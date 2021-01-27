//
//  FolderViewController + TableViewDelegate.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 09/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for table view datasource and delegate.

import Foundation
import UIKit
import PDFKit
import Firebase

extension FolderViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDocuments?.count ?? 6
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subject = Files.sharedInstance.arrayOfFiles[indexPath.row]
        
        if !subject.folder {
            downloadView.isHidden = false
            indicator.startAnimating()
            
            DispatchQueue.main.async() {
                self.downloadFile(url: "https://is.stuba.sk/auth/dok_server/" + Files.sharedInstance.arrayOfFiles[indexPath.row].fileDownload)
                if Files.sharedInstance.arrayOfFiles[indexPath.row].isPDF {
                    self.showPdf()
                }
                else {
                    let fileManager = FileManager.default

                    if fileManager.fileExists(atPath: self.pdfURL.path) {
                        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [self.pdfURL!], applicationActivities: nil)
                        activityViewController.popoverPresentationController?.sourceView = self.view
                        self.present(activityViewController, animated: true, completion: nil)
                        self.downloadView.isHidden = true
                        self.indicator.stopAnimating()
                        Analytics.logEvent("file_shared", parameters: nil)
                    } else {
                        self.showAlertWindow(title: "Dokument nebol nájdený", message: "Nastala chyba pri vyhľadávaní dokumentu!")
                    }
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentDetailCell", for: indexPath) as! DocumentDetailTableViewCell
        cell.pdfView.isHidden = true
        if !showSkeleton {
            cell.hideAnimation()
        }
        
        if arrayDocuments != nil {
            cell.hideAnimation()
            let document = arrayDocuments![indexPath.row]
            cell.fileName.text = document.fileName
            if document.isPDF {
                cell.pdfView.isHidden = false
            }
        }
        
        return cell
    }
}
