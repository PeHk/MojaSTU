//
//  MailboxViewController+tableViewDataSource.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 04/04/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension MailboxViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mailboxArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mailboxCell", for: indexPath) as! MailboxCell
        
        if mailboxArray != nil {
            cell.nameLabel.text = mailboxArray![indexPath.row].name
            cell.count.text = mailboxArray![indexPath.row].count
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mailboxArray != nil {
            let selected = mailboxArray![indexPath.row]
            let currentURL = "https://is.stuba.sk/auth/posta/slozka.pl?;fid=\(selected.id);on=0;lang=\(language)"
            let mailboxDict:[String: Any] = ["url": currentURL, "name": selected.name, "flag" : true]
            NotificationCenter.default.post(name: .mailboxChanged, object: nil, userInfo: mailboxDict)
            dismiss(animated: true, completion: nil)
        }
    }
}
