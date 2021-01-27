//
//  PlacesDownloadViewController+TableViewDelegate.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 09/06/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension PlacesDownloadViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filesArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "downloadCell", for: indexPath) as! PlacesDownloadCell
        
        if filesArray != nil {
            cell.nameLabel.text = filesArray![indexPath.row].name
            print(filesArray![indexPath.row].link)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = filesArray![indexPath.row]
        
        if !file.link.isEmpty {
            downloadView.isHidden = false
            downloadIndicator.startAnimating()
            
            DispatchQueue.main.async() {
                self.downloadFile(url: "https://is.stuba.sk" + file.link, name: file.name)
                let fileManager = FileManager.default
                
                if fileManager.fileExists(atPath: self.fileURL.path) {
                    let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [self.fileURL!], applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    self.present(activityViewController, animated: true, completion: nil)
                    self.downloadIndicator.stopAnimating()
                    self.downloadView.isHidden = true
                    Analytics.logEvent("file_shared", parameters: nil)
                } else {
                    self.showAlertWindow(title: "Dokument nebol nájdený", message: "Nastala chyba pri vyhľadávaní dokumentu!")
                }
            }
        }
    }
    
    func downloadFile(url: String, name: String) {
        network.postFileWithName(url: url, fileName: name, completion:{result, statusCode, success in
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
