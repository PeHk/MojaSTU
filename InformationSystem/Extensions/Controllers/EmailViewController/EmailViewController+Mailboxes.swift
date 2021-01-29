//
//  EmailViewController+Mailboxes.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 31/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension handling button for mailboxes.

import Foundation
import UIKit

extension EmailViewController {
//    MARK: Adding button
    func addMailboxesButton() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setTitle(self.mailboxesString, for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(openMailboxes), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        addNewMessageButton()
    }
    
    func addNewMessageButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.compose,
        target: self,
        action: #selector(createNewMessage))
    }
//    MARK: Handling button
    @objc func openMailboxes(){
        if  let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: "MailboxViewController") as? MailboxViewController {
            destinationViewController.mailboxArray = arrayMailbox
            if linkToTrash != nil {
                destinationViewController.trashLink = linkToTrash!
            }
            present(destinationViewController, animated: true, completion: nil)
        }
    }
}
