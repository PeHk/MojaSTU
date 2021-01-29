//
//  EIndexViewController+RefreshingData.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 24/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for pull-to-refresh on table view, with timer to block often refreshing

import Foundation
import UIKit
import Firebase

extension EIndexViewController {
//    MARK: Refresh data
    @objc func refreshData(_ sender: Any) {
        if refreshPossible {
            self.arraySubjects = nil
            self.tableView.reloadData()
            DispatchQueue.global().async {
        
                self.getSubjectTable(url: self.mainURL, urlForMarks: self.mainMarksURL)
                self.arraySubjects = EIndexSubject.sharedInstance.arrayOfSubjects
                
                DispatchQueue.main.async {
                    self.tableView.reloadSections([0], with: .automatic)
                    self.startTimer()
                    self.refreshControl.endRefreshing()
                    Analytics.logEvent("eIndex_reloaded", parameters: nil)
                }
            }
        }
        else {
            self.blockRefreshAlert(title: blockRefresh, message: blockRefreshString)
        }
    }
    
//    MARK: Block refreshing
    func blockRefreshAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{(action:UIAlertAction!) in
            self.refreshControl.endRefreshing()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func allowRefresh() {
        self.refreshPossible = true
    }
    
    func startTimer(){
        timer?.invalidate()
        let nextTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(allowRefresh), userInfo: nil, repeats: false)
        timer = nextTimer
    }
    
}
