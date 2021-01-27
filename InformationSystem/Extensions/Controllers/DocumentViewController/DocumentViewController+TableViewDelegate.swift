//
//  DocumentViewController+TableViewDelegate.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 03/01/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for table datasource and delegate.

import Foundation
import UIKit

extension DocumentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .fade)
        if  let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: "DocumentDetailViewController") as? DocumentDetailViewController{
            destinationViewController.subject = Documents.sharedInstance.arrayOfDocuments[indexPath.row]
            navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySubjects?.count ?? 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath) as! DocumentTableViewCell
        
        if arraySubjects != nil {
            cell.hideAnimation()
            cell.changeMode()
            let subject = arraySubjects![indexPath.row]
            cell.nameLabel?.text = subject.subjectName
        }
        return cell
    }
}
