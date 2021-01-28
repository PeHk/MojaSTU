//
//  EmailViewController.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 28/12/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import UIKit
import Firebase
import SnapKit
import SwiftEmptyState
import StoreKit

class EmailViewController: UIViewController {
       
//    MARK: Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.refreshControl = refreshControl
            tableView.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var tableHeaderView: UIView! 
    @IBOutlet weak var emailsNameLabel: UILabel!
    @IBOutlet weak var notificationPanel: UIView! {
        didSet {
            notificationPanel.isHidden = true
            notificationPanel.layer.cornerRadius = 20
        }
    }
    
//    MARK: Constants
    
    let newEmailURL = "https://is.stuba.sk/auth/posta/nova_zprava.pl?lang=sk"
    
//    MARK: Variables
    var emailsURL = "https://is.stuba.sk/auth/posta/slozka.pl?on=0;lang=sk"
    var folderID = String()
    var HTML = String()
    var newEmail = String()
    var newEmailObject = Email()
    var arrayEmails : [Email]?
    var arrayMailbox : [Mailbox]?
    var activityIndicator: LoadMoreActivityIndicator!
    var pageNumber = 0
    var countOfEmails = Int()
    var refreshPossible = false
    var reloadFlag = false
    var isEmpty = false
    var errorCounter = 0
    var sended = false
    var mailboxFlag = false
    var mailboxName = "Doručená pošta"
    var linkToTrash : String?
    weak var timer: Timer?
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Načítavam...")
        
        return refreshControl
    }()
    
//    MARK: Empty table
    lazy var noEmailsView = EmptyStateView(
        messageText: "V tomto priečinku nemáš žiadne správy!",
        titleText: "Žiadne správy",
        image: UIImage(named: "emptyFiles")
    )
    lazy var noEmails: EmptyStateManager = {
        
        let manager = EmptyStateManager(
            containerView: self.tableView,
            emptyView: self.noEmailsView,
            animationConfiguration: .init(animationType: .fromBottom)
        )
        manager.hasContent = {
            !(self.isEmpty)
        }
        
        return manager
    }()
    
    lazy var reloadingEmailsView = EmptyStateView(
        messageText: "",
        titleText: "Načítavam...",
        image: UIImage(named: "reload")
    )
    lazy var reloadingEmails: EmptyStateManager = {
        
        let manager = EmptyStateManager(
            containerView: self.tableView,
            emptyView: self.reloadingEmailsView,
            animationConfiguration: .init(animationType: .fromBottom)
        )
        manager.hasContent = {
            !(self.mailboxFlag)
        }
        
        return manager
    }()
    
//    MARK: Instances
    let network: Network = Network()
    let htmlparser: HTMLParser = HTMLParser()
    let stringparser: StringParser = StringParser()
    let review: Review = Review()
    
//    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = LoadMoreActivityIndicator(scrollView: tableView, spacingFromLastCell: 10, spacingFromLastCellWhenLoadMoreActionStart: 60)
        
        initObservers()
        checkObservers()
        
        emailsNameLabel.text = mailboxName
    
        NotificationCenter.default.addObserver(self, selector: #selector(createNewSerialCode(_:)), name: .messageWasSent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorNotification(_:)), name: .messageWasNotSent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(mailboxChanged(_:)), name: .mailboxChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshBadge(_:)), name: .checkEmailsCount, object: nil)
        
        let doRefresh = UserDefaults.standard.value(forKey: "email_refresh")
        if (doRefresh != nil && doRefresh! as! Bool == true) {
            UserDefaults.standard.set(false, forKey: "email_refresh")
        }
        
        DispatchQueue.global().async {
            self.getAllEmails(url: self.emailsURL)
            self.newMessageHtml(url: self.newEmailURL)
            self.arrayEmails = self.htmlparser.getEmails(html: self.HTML)
            self.arrayMailbox = self.htmlparser.getMailboxes(fromHtml: self.HTML)
            self.linkToTrash = self.htmlparser.getTrash(fromHtml: self.HTML)
            DispatchQueue.main.async {
                self.startTimer()
                if self.arrayMailbox != nil {
                    self.addMailboxesButton()
                }
                self.tableView.reloadSections([0], with: UITableView.RowAnimation.automatic)
                self.tableView.isUserInteractionEnabled = true
                if self.arrayEmails?.count == 0 {
                    self.isEmpty = true
                }
                self.noEmails.reloadState()
                Analytics.logEvent("email_Loaded", parameters: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkObservers()
        tableView.reloadData()
        review.incrementOpen()
        Analytics.logEvent("tabEmailsLoaded", parameters: nil)
        
        let doRefresh = UserDefaults.standard.value(forKey: "email_refresh")
        if (doRefresh != nil && doRefresh! as! Bool == true) {
            arrayEmails = nil
            reloadFlag = true
            tableView.reloadData()
            refreshControl.sendActions(for: .valueChanged)
            UserDefaults.standard.set(false, forKey: "email_refresh")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .messageWasSent, object: nil)
        NotificationCenter.default.removeObserver(self, name: .messageWasNotSent, object: nil)
        NotificationCenter.default.removeObserver(self, name: .checkEmailsCount, object: nil)
        
    }
    
    @IBAction func refreshBadge(_ notification: Notification) {
        setBadgeDirectly()
        let doRefresh = UserDefaults.standard.value(forKey: "email_refresh")
        if (doRefresh != nil && doRefresh! as! Bool == true) {
            arrayEmails = nil
            reloadFlag = true
            tableView.reloadData()
            refreshControl.sendActions(for: .valueChanged)
            UserDefaults.standard.set(false, forKey: "email_refresh")
        }
    }
    
//    MARK: Serial code
    @IBAction func createNewSerialCode(_ notification: Notification) {
        DispatchQueue.main.async {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.notificationLabel.text = "Správa bola úspešne odoslaná!"
                self.showPanel()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.hidePanel()
                }
            }
            self.newMessageHtml(url: self.newEmailURL)
        }
    }
    
    @IBAction func showErrorNotification(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.notificationLabel.text = "Správa nebola odoslaná!"
            self.showPanel()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.hidePanel()
            }
        }
    }
    
    @IBAction func mailboxChanged(_ notification: Notification) {
        if notification.userInfo?["name"] != nil {
            emailsNameLabel.text = (notification.userInfo?["name"] as! String)
        }
        
        if notification.userInfo?["url"] != nil {
            emailsURL = notification.userInfo?["url"] as! String
        }
        
        if notification.userInfo?["flag"] != nil {
            mailboxFlag = notification.userInfo?["flag"] as! Bool
        }
        isEmpty = false
        self.noEmails.reloadState()
        arrayEmails?.removeAll()
        tableView.reloadData()
        reloadingEmails.reloadState()
        
        DispatchQueue.global().async {
            self.getAllEmails(url: self.emailsURL)
            self.newMessageHtml(url: self.newEmailURL)
            self.arrayEmails = self.htmlparser.getEmails(html: self.HTML)
            self.arrayMailbox = self.htmlparser.getMailboxes(fromHtml: self.HTML)
            self.linkToTrash = self.htmlparser.getTrash(fromHtml: self.HTML)
            DispatchQueue.main.async {
                self.startTimer()
                if self.arrayMailbox != nil {
                    self.addMailboxesButton()
                }
                self.tableView.reloadSections([0], with: UITableView.RowAnimation.automatic)
                self.tableView.isUserInteractionEnabled = true
                if self.arrayEmails?.count == 0 {
                    self.isEmpty = true
                }
                self.mailboxFlag = false
                self.noEmails.reloadState()
                self.reloadingEmails.reloadState()
                Analytics.logEvent("email_Loaded", parameters: nil)
            }
        }
    }
    
    func showPanel() {
        notificationPanel.alpha = 0
        notificationPanel.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.notificationPanel.alpha = 1
        }
    }
    
    func hidePanel() {
        UIView.animate(withDuration: 0.3, animations: {
            self.notificationPanel.alpha = 0
        }) { (finished) in
            self.notificationPanel.isHidden = finished
        }
    }

//      MARK: Create new message
    @objc func createNewMessage () {
        let storyboard = UIStoryboard(name: "MailClient", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "NewMessageController") as! NewMessageViewController
        vc.newEmail = newEmailObject
        vc.folderID = folderID
        vc.isAnswer = false
        self.present(vc, animated: true, completion: nil)
    }
    
//     MARK: Error occurred
    func errorOccurred(errorCounter: Int, url: String, type: Int) {
        if errorCounter <= 3 {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Nastala chyba, skontrolujte si internetové pripojenie alebo prihlasovacie údaje!", message: "Počet pokusov na pripojenie: \(3 - errorCounter). Tlačidlom zrušiť zavriete aplikáciu!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Zrušiť", style: .destructive, handler: { action in
                    exit(0)
                }))
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                    self.requestForNewToken()
                    if type == 1 {
                        self.newMessageHtml(url: url)
                    }
                    else if type == 2 {
                        self.getAllEmails(url: url)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else {
            DispatchQueue.main.async {
                self.resetDefaults()
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc : UIViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController;
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
//    MARK: Get new message
    func newMessageHtml(url: String) {
        network.getRequest(urlAsString: url, completionHandler: { success, statusCode, result in
            if !success {
                self.errorCounter += 1
                self.errorOccurred(errorCounter: self.errorCounter, url: url, type: 1)
            }
            else {
                if result != nil {
                    self.newEmailObject = self.htmlparser.getSerialization(fromHtml: result!)
                }
                else {
                    self.errorCounter += 1
                    self.errorOccurred(errorCounter: self.errorCounter, url: url, type: 1)
                }
            }
        })
    }
//    MARK: Get emails
    func getAllEmails(url: String) {
        refreshPossible = false
        network.getRequest(urlAsString: url, completionHandler: { success, statusCode, result in
            if !success {
                self.errorCounter += 1
                self.errorOccurred(errorCounter: self.errorCounter, url: url, type: 2)
                Analytics.logEvent("error_emailLoading", parameters: ["stastusCode": statusCode])
            }
            else {
                if result != nil {
                    self.countOfEmails = self.htmlparser.getCountOfEmails(fromHtml: result!)
                    self.folderID = self.htmlparser.getFolderID(fromHtml: result!)
                    self.HTML = result!
                    DispatchQueue.main.async {
                        self.setBadge(html: result!)
                    }
                }
                else {
                    self.errorCounter += 1
                    self.errorOccurred(errorCounter: self.errorCounter, url: url, type: 2)
                    Analytics.logEvent("error_emailLoading", parameters: ["stastusCode": statusCode])
                }
            }
        })
    }
}
