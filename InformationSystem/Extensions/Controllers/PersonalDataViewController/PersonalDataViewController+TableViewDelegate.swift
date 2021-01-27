//
//  PersonalDataViewController+TableViewDelegate.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 12/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for table datasource and delegate.

import Foundation
import UIKit

extension PersonalDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalDataCell", for: indexPath) as! PersonalDataTableViewCell
        cell.checkMode()
        if arrayOfData != nil {
            cell.title.text = arrayOfData![indexPath.row].key
            cell.subtitle.text = arrayOfData![indexPath.row].value
        }
        return cell
    }
}
