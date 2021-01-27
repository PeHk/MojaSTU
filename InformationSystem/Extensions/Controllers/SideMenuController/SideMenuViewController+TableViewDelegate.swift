//
//  SideMenuViewController+TableViewDelegate.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 03/01/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for table datasource and table delegate in SideMenuController.

import Foundation
import UIKit
import Firebase

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SideMenuTableViewCell
        
        let setting = arrayOfSettings[indexPath.row]
        cell.changeMode()
        cell.cellName.text = setting
        
        if (indexPath.row != 2) {
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .fade)
        if (indexPath.row == 0) {
            let storyboard = UIStoryboard(name: "TimeTable", bundle: nil);
            let vc = storyboard.instantiateViewController(withIdentifier: "PersonalDataController")
            self.present(vc, animated: true, completion: nil)
        }
        else if (indexPath.row == 1) {
            let storyboard = UIStoryboard(name: "TimeTable", bundle: nil);
            let vc = storyboard.instantiateViewController(withIdentifier: "SettingsController")
            self.present(vc, animated: true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (indexPath.row == 2) {
            resetDefaults()
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil);
            Analytics.logEvent("logout", parameters: nil)
        }
    }
}
