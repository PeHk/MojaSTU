//
//  TestsViewController+RefreshData.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 03/06/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension TestsViewController {
    //    MARK: Refresh data
    @objc func refreshData(_ sender: Any) {
        if refreshPossible {
            DispatchQueue.global().async {
                
                self.getTests(url: self.mainURL)
                
                DispatchQueue.main.async {
                    self.tableView.reloadSections([0], with: .automatic)
                    self.startTimer()
                    self.refreshControl.endRefreshing()
                    Analytics.logEvent("tests_reloaded", parameters: nil)
                }
            }
        }
        else {
            self.blockRefreshAlert(title: "Aktualizácia blokovaná", message: "Aktualizácia je možná len raz za 5 sekúnd!")
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
        let nextTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(allowRefresh), userInfo: nil, repeats: false)
        timer = nextTimer
    }
    
    
}
