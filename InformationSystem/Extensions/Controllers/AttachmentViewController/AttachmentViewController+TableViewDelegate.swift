//
//  AttachmentViewController+TableViewDelegate.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 30/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extenstion for table datasource and delegate.

import Foundation
import UIKit

extension AttachmentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attachmentArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .fade)
        loadingView.isHidden = false
        indicator.startAnimating()
        DispatchQueue.global().async {
            self.downloadFile(url: self.attachmentArray[indexPath.row].link, fileName: self.attachmentArray[indexPath.row].name)
            DispatchQueue.main.async {
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: self.fileURL.path) {
                    let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [self.fileURL!], applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    self.present(activityViewController, animated: true, completion: nil)
                    self.loadingView.isHidden = true
                    self.indicator.stopAnimating()
                } else {
                    self.showAlertWindow(title: self.notFoundTitle, message: self.notFoundText)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "attachmentCell", for: indexPath) as! AttachmentTableViewCell
        
        cell.nameLabel.text = attachmentArray[indexPath.row].name
        
        return cell
    }
}
