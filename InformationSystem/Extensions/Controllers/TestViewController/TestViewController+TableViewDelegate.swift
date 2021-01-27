//
//  TestViewController+TableViewDelegate.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 03/06/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension TestsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath) as! TestsTableViewCell
        
        if arrayTests != nil {
            tableView.isUserInteractionEnabled = true
            cell.hideAnimation()
            let test = arrayTests![indexPath.row]
            
            cell.testNameLabel.text = test.testName

            if test.allPoints == "" && test.myPoints == "" {
                cell.myPoints.text = "Skryté"
                cell.myPoints.textColor = .systemRed
                cell.allPoints.isHidden = true
            }
            else {
                let perc = ((Double(test.myPoints) ?? 1) / (Double(stringparser.suffixWithoutVal(value: "/ ", string: test.allPoints)) ?? 1) * 100)
                
                cell.allPoints.text = test.allPoints
                cell.myPoints.text = test.myPoints
                
                if perc < 20 {
                    cell.myPoints.textColor = UIColor.init(hex: "#ab0000ff")
                }
                else if perc < 40 && perc > 20 {
                    cell.myPoints.textColor = .orange
                }
                else if perc > 40 && perc < 80 {
                    cell.myPoints.textColor = UIColor.init(hex: "#e6bf00ff")
                }
                else {
                    cell.myPoints.textColor = UIColor.init(hex: "#00a824ff")
                }
            }
            
            if test.pointsToAdd != nil {
                cell.pointsToAdd.text = test.pointsToAdd!
            }
            else {
                cell.pointsToAdd.isHidden = true
            }
        }
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTests?.count ?? 3
    }
    
}
