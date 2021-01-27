//
//  NotificationViewController+TableViewDelegate.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 03/01/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for table datasource and delegate.

import Foundation
import UIKit

extension PersonViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonViewControllerCell
        cell.changeMode()
        if peopleArray != nil {
            cell.nameLabel.text = peopleArray![indexPath.row].name
            cell.acronymLabel.text = peopleArray![indexPath.row].acronym
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .fade)
        let selected = peopleArray![indexPath.row]
        if let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: "personDetailTableViewController") as? PersonDetailTableViewController {
            destinationViewController.name = selected.name
            destinationViewController.id = selected.id
            destinationViewController.study = selected.study
            navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
}
