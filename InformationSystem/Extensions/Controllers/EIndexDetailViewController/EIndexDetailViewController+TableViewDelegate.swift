//
//  EIndexDetailViewController+TableViewDelegate.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 06/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for table datasource and delegate.

import Foundation
import UIKit

extension EIndexDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayOfTables[section].opened {
            return arrayOfTables[section].dictionary.count
        }
        else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfTables.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell") as? EIndexDetailViewSectionCell else {return UITableViewCell()}
            cell.changeMode()
            cell.name.text = arrayOfTables[indexPath.section].name
            
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RowCell") as? EIndexDetailTableViewCell else {return UITableViewCell()}
            cell.changeMode()
            cell.name.text = arrayOfTables[indexPath.section].dictionary[indexPath.row].key
            cell.value.text = arrayOfTables[indexPath.section].dictionary[indexPath.row].value
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrayOfTables[indexPath.section].opened {
            arrayOfTables[indexPath.section].opened = false
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }
        else {
            arrayOfTables[indexPath.section].opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }
    }
}

