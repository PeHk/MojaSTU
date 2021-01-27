//
//  EmailViewController+Refresh.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 29/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for fetching new emails to tableview.

import Foundation
import UIKit
import Firebase

extension EmailViewController {
//    MARK: Pull to refresh
    @objc func refreshData(_ sender: Any) {
        if refreshPossible {
            self.arrayEmails = nil
            self.tableView.isUserInteractionEnabled = false
            DispatchQueue.global().async {
                
                self.getAllEmails(url: self.emailsURL)
                self.newMessageHtml(url: self.newEmailURL)
                self.arrayEmails = self.htmlparser.getEmails(html: self.HTML)
                
                DispatchQueue.main.async {
                    self.tableView.reloadSections([0], with: .automatic)
                    self.startTimer()
                    self.refreshControl.endRefreshing()
                    self.tableView.isUserInteractionEnabled = true
                    Analytics.logEvent("email_Reloaded", parameters: nil)
                    self.reloadFlag = false
                }
            }
        }
        else {
            blockRefreshAlert(title: "Aktualizácia blokovaná", message: "Aktualizácia je možná len raz za 5 sekúnd!")
        }
    }
    
    @objc func allowRefresh() {
        self.refreshPossible = true
    }
//    MARK: Timer
    func startTimer(){
        timer?.invalidate()
        let nextTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(allowRefresh), userInfo: nil, repeats: false)
        timer = nextTimer
    }
//    MARK: Alert box
    func blockRefreshAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{(action:UIAlertAction!) in
            self.refreshControl.endRefreshing()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
//     MARK: Append new emails
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var countOfObjects = Int()
        if self.arrayEmails?.count != 0 {
            countOfObjects = self.arrayEmails?.count ?? 0
        }
        if countOfObjects != self.countOfEmails {
            activityIndicator.start {
                self.view.isUserInteractionEnabled = false
                DispatchQueue.global(qos: .utility).async {
                    self.pageNumber = self.pageNumber + 1
                    
                    var newURL = self.emailsURL
                    if let startIndex = self.emailsURL.index(of: "on=") {
                        if let endIndex = self.emailsURL[startIndex...].index(of: ";") {
                            newURL = self.emailsURL.replacingCharacters(in: startIndex...endIndex, with: "on=\(String(self.pageNumber));")
                        }
                    }
                    self.getAllEmails(url: newURL)
                    self.arrayEmails?.append(contentsOf: self.htmlparser.getEmails(html: self.HTML))
                    sleep(1)
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.activityIndicator.stop()
                        self?.tableView.reloadData()
                        self?.view.isUserInteractionEnabled = true
                        self?.allowRefresh()
                        Analytics.logEvent("email_NextPageLoaded", parameters: nil)
                    }
                }
            }
        }
    }
}
