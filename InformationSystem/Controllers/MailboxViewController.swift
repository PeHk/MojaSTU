//
//  MailboxViewController.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 04/04/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import UIKit
import Firebase

class MailboxViewController: UIViewController {

    @IBOutlet weak var deleteTrash: UIButton! {
        didSet {
            deleteTrash.isHidden = true
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var tableHeaderView: UIView!
    
    var mailboxArray : [Mailbox]?
    var trashLink = String()
    var emailsURL = "https://is.stuba.sk/auth/posta/slozka.pl?on=0;lang=sk"
    
//    MARK: Instances
    let network: Network = Network()
    let htmlparser: HTMLParser = HTMLParser()
    let stringparser: StringParser = StringParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
        checkDarkMode()
        
        if !trashLink.isEmpty {
            deleteTrash.isHidden = false
        }
        Analytics.logEvent("mailboxesOpened", parameters: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    @IBAction func deleteTrashTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Vysypať kôš?", message: "Naozaj si želáte vymazať všetky správy z priečinka Kôš?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Vysypať", style: .destructive, handler: { action in
            DispatchQueue.global().async {
                self.network.getRequest(urlAsString: "https://is.stuba.sk/auth/posta/" + self.trashLink, completionHandler: { success, statusCode, result in
                    if !success {
                        self.showAlertWindow(title: "Oops!", message: "Nepodarilo sa vymazať kôš!")
                    }
                    else {
                        DispatchQueue.main.async {
                            self.deleteTrash.isHidden = true
                        }
                    }
                })
            }
        }))
        alert.addAction(UIAlertAction(title: "Zrušiť", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}