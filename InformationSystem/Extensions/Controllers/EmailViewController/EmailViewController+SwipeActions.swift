//
//  EmailViewController+SwipeActions.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 29/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for handling table cell actions.

import Foundation
import UIKit
import Firebase

extension EmailViewController {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var emailLink = self.arrayEmails?[indexPath.row].httpLink ?? ""
            if !emailLink.isEmpty {
                emailLink = emailLink.replacingOccurrences(of: "email.pl?", with: "slozka.pl?")
                emailLink = emailLink.replacingOccurrences(of: "lang=sk", with: "menu_akce=vymazat;lang=sk")
                DispatchQueue.global().async {
                    self.doActionEmail(url: "https://is.stuba.sk/auth/posta" + emailLink)
                    self.refreshPossible = true
                }
                tableView.beginUpdates()
                arrayEmails?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                noEmails.reloadState()
                tableView.endUpdates()
            }
        }
    }

    //    MARK: Network connection
    func doActionEmail(url: String) {
        network.getRequest(urlAsString: url, completionHandler: { success, statusCode, result in
            if !success {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: self.errorAction, message: self.errorActionString, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    Analytics.logEvent("error_trailingActionEmail", parameters: ["statusCode": statusCode])
                }
            }
            else {
                if result != nil {
                    DispatchQueue.main.async {
                        self.setBadge(html: result!)
                    }
                }
            }
        })
    }
}
