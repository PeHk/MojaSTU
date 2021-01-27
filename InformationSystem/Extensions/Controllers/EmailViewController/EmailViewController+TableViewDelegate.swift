//
//  EmailViewController+TableViewDelegate.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 03/01/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension handling table datasource and delegate.

import Foundation
import UIKit
import Firebase

extension EmailViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayEmails?.count ?? 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmailCell", for: indexPath) as! EmailTableViewCell
        
        if reloadFlag {
            cell.dateOfEmail.text = "Date"
            cell.timeOfEmail.text = "Time"
            cell.subjectOfEmail.showAnimatedGradientSkeleton()
            cell.senderOfEmail.showAnimatedGradientSkeleton()
            cell.dateOfEmail.showAnimatedGradientSkeleton()
            cell.timeOfEmail.showAnimatedGradientSkeleton()
        }
        
        cell.unreadMarkView.isHidden = true
        cell.attachmentView.isHidden = true
        if arrayEmails != nil && arrayEmails!.count > 0 {
            let email = arrayEmails![indexPath.row]
            cell.hideAnimation()
            cell.checkMode()
            cell.subjectOfEmail.text = email.subject
            cell.senderOfEmail.text = email.name
            cell.timeOfEmail.text = email.time
            cell.dateOfEmail.text = email.date
            if email.unread {
                cell.unreadMarkView.isHidden = false
            }
            if email.attachment {
                cell.attachmentView.isHidden = false
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmailCell", for: indexPath) as! EmailTableViewCell
        if  let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: "EmailDetailViewController") as? EmailDetailViewController {
            cell.unreadMarkView.isHidden = true
            tableView.reloadRows(at: [indexPath], with: .fade)
            destinationViewController.emailObject = arrayEmails![indexPath.row]
            navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
}

extension UITableView {
    public func beginRefreshing() {
        // Make sure that a refresh control to be shown was actually set on the view
        // controller and the it is not already animating. Otherwise there's nothing
        // to refresh.
        guard let refreshControl = refreshControl, !refreshControl.isRefreshing else {
          return
        }
        
        // Start the refresh animation
        refreshControl.beginRefreshing()

        // Make the refresh control send action to all targets as if a user executed
        // a pull to refresh manually
        refreshControl.sendActions(for: .valueChanged)

        // Apply some offset so that the refresh control can actually be seen
        let contentOffset = CGPoint(x: 0, y: -refreshControl.frame.height)
        setContentOffset(contentOffset, animated: true)
      }
}

