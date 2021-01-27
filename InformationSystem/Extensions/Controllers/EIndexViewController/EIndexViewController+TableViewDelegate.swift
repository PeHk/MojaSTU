//
//  EIndexViewController+TableViewDelegate.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 03/01/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for table datasource and delegate.

import Foundation
import UIKit

extension EIndexViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySubjects?.count ?? 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .fade)
        if let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: "EIndexDetailViewController") as? EIndexDetailViewController {
            destinationViewController.subject = EIndexSubject.sharedInstance.arrayOfSubjects[indexPath.row]
            navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EIndexCell", for: indexPath) as! EIndexTableViewCell
        
        if reloadFlag {
            cell.nameLabel.showAnimatedGradientSkeleton()
            cell.evaluationView.showAnimatedGradientSkeleton()
            testsLabel.showAnimatedGradientSkeleton()
            testIcon.showAnimatedGradientSkeleton()
            placesLabel.showAnimatedGradientSkeleton()
            placesIcon.showAnimatedGradientSkeleton()
        }
    
        tableView.isUserInteractionEnabled = false
        
        if arraySubjects != nil {
            cell.hideAnimation()
            testsLabel.hideSkeleton()
            testIcon.hideSkeleton()
            placesIcon.hideSkeleton()
            placesLabel.hideSkeleton()
            let isDarkMode = UserDefaults.standard.bool(forKey: "darkModeEnabled")
            if isDarkMode {
                placesLabel.textColor = .white
                testsLabel.textColor = .white
                testsView.backgroundColor = .black
                placesView.backgroundColor = .black
            }
            else {
                placesLabel.textColor = .black
                testsLabel.textColor = .black
                testsView.backgroundColor = .white
                placesView.backgroundColor = .white
            }
            testsView.isUserInteractionEnabled = true
            placesView.isUserInteractionEnabled = true
            cell.changeMode()
            tableView.isUserInteractionEnabled = true
            let subject = arraySubjects![indexPath.row]
            cell.evaluationView.layer.cornerRadius = (cell.evaluationView.frame.height) / 2
            cell.nameLabel?.text = subject.subjectName
            cell.evaluationLabel.text = subject.subjectMark
        }
        return cell
    }

}


