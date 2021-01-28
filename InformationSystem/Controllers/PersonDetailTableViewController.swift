//
//  PersonDetailTableViewController.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 10/09/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import UIKit
import SkeletonView
import MessageUI
import Firebase

class PersonDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var photoCell: UITableViewCell!
    @IBOutlet weak var infoCell: UITableViewCell!
    @IBOutlet weak var buttonsCell: UITableViewCell!
    @IBOutlet weak var studyLabel: UILabel! {
        didSet {
            studyLabel.text = study
        }
    }
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.text = name
        }
    }
    @IBOutlet weak var idLabel: UILabel! {
        didSet {
            idLabel.text = id
        }
    }
    @IBOutlet weak var activityIn: UIActivityIndicatorView! {
        didSet {
            activityIn.startAnimating()
        }
    }
    @IBOutlet weak var activityOut: UIActivityIndicatorView! {
        didSet {
            activityOut.startAnimating()
        }
    }
    @IBOutlet weak var contactLabel: UILabel! {
        didSet {
            contactLabel.isHidden = true
        }
    }
    @IBOutlet weak var idStatic: UILabel!
    @IBOutlet weak var nameStatic: UILabel!
    @IBOutlet weak var studyStatic: UILabel!
    @IBOutlet weak var photoView: UIImageView! {
        didSet {
            photoView.layer.cornerRadius = (photoView.frame.height) / 2
            photoView.layer.masksToBounds = true
            photoView.showAnimatedGradientSkeleton()
            photoView.contentMode = .scaleAspectFill
        }
    }
    
    @IBOutlet weak var outEmailLabel: UILabel! {
        didSet {
            outEmailLabel.isHidden = true
        }
    }
    @IBOutlet weak var appEmailLabel: UILabel! {
        didSet {
            appEmailLabel.isHidden = true
        }
    }
    @IBOutlet weak var emailOutLogo: UIImageView! {
        didSet {
            emailOutLogo.isHidden = true
        }
    }
    @IBOutlet weak var emailInLogo: UIImageView! {
        didSet {
            emailInLogo.isHidden = true
        }
    }
    @IBOutlet weak var stackViewOut: UIStackView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(emailOutTapped))
            stackViewOut.addGestureRecognizer(tap)
            stackViewOut.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var stackViewIn: UIStackView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(emailInTapped))
            stackViewIn.addGestureRecognizer(tap)
            stackViewIn.isUserInteractionEnabled = false
        }
    }
    
    //    MARK: Variables
    var name = String()
    var id = String()
    var study = String()
    var emailIn : String?
    var emailOut : String?
    var errorCounter = 0
    var newEmailObject = Email()
    var folderID = String()
    
    //    MARK: Constants
    let imageURL = "https://is.stuba.sk/auth/lide/foto.pl?id="
    let personURL = "https://is.stuba.sk/auth/lide/clovek.pl?id="
    let newEmailURL = "https://is.stuba.sk/auth/posta/nova_zprava.pl?lang=sk"
    let emailsURL = "https://is.stuba.sk/auth/posta/slozka.pl?on=0;lang=sk"
    
    //    MARK: Instances
    let network = Network()
    let htmlParser = HTMLParser()

    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
        checkObservers()
        Analytics.logEvent("personDetailLoaded", parameters: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(createNewSerialCode(_:)), name: .messageWasSent, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorNotification(_:)), name: .messageWasNotSent, object: nil)

        DispatchQueue.global().async {
            self.newMessageHtml(url: self.newEmailURL)
            self.network.getData(urlAsString: self.imageURL+self.id, completionHandler: {success, data in
                if success {
                    if data != nil {
                        DispatchQueue.main.async {
                            self.photoView.hideSkeleton()
                            self.photoView.image = UIImage(data: data!)
                        }
                    }
                }
            })
            self.getDetails()
            self.getFolder(url: self.emailsURL)
        }
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .messageWasSent, object: nil)
        NotificationCenter.default.removeObserver(self, name: .messageWasNotSent, object: nil)
    }
    
    //    MARK: Email in
    @objc func emailInTapped() {
        let storyboard = UIStoryboard(name: "MailClient", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "NewMessageController") as! NewMessageViewController
        vc.newEmail = newEmailObject
        vc.personFinder = true
        vc.recipient = emailIn!
        vc.folderID = folderID
        vc.isAnswer = false
        self.present(vc, animated: true, completion: nil)
    }
    
    //    MARK: Email out
    @objc func emailOutTapped() {
        showMessageComposer(recipientEmail: emailOut!)
    }
    
    //    MARK: Get email serialization
    func newMessageHtml(url: String) {
        network.getRequest(urlAsString: url, completionHandler: { success, statusCode, result in
            if !success {
                self.errorCounter += 1
                self.errorOccurred(errorCounter: self.errorCounter, url: url, type: 2)
            }
            else {
                if result != nil {
                    self.newEmailObject = self.htmlParser.getSerialization(fromHtml: result!)
                }
                else {
                    self.errorCounter += 1
                    self.errorOccurred(errorCounter: self.errorCounter, url: url, type: 2)
                }
            }
        })
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
                        self.getDetails()
                    }
                    else if type == 2 {
                        self.newMessageHtml(url: self.newEmailURL)
                    }
                    else if type == 3 {
                        self.getFolder(url: self.emailsURL)
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
    
    @IBAction func showErrorNotification(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.notificationLabel.text = "Správa nebola odoslaná!"
//            self.showPanel()
            self.title = "Správa nebola odoslaná!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                self.hidePanel()
                self.title = ""
            }
        }
    }
    
    //    MARK: Serial code
    @IBAction func createNewSerialCode(_ notification: Notification) {
        DispatchQueue.main.async {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                self.notificationLabel.text = "Správa bola úspešne odoslaná!"
                self.title = "Správa bola úspešne odoslaná!"
//                self.showPanel()
//                self.notificationPanel.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                    self.hidePanel()
                    self.title = ""
                }
            }
            self.newMessageHtml(url: self.newEmailURL)
        }
    }
    
//    func showPanel() {
            
//            notificationPanel.alpha = 0
//            notificationPanel.isHidden = false
//            UIView.animate(withDuration: 0.3) {
//                self.notificationPanel.alpha = 1
//            }
//        }
//
//        func hidePanel() {
//            UIView.animate(withDuration: 0.3, animations: {
//                self.notificationPanel.alpha = 0
//            }) { (finished) in
//                self.notificationPanel.isHidden = finished
//            }
//        }
//
    //    MARK: Get details of person
        func getDetails() {
            let url = personURL + id + ";lang=sk;"
            network.getRequest(urlAsString: url, completionHandler: { success, statusCode, result in
                if success {
                    if result != nil {
                        let emails = self.htmlParser.getPersonDetails(fromHtml: result!)
                        self.emailIn = emails.0
                        self.emailOut = emails.1
                        DispatchQueue.main.async {
                            self.activityOut.isHidden = true
                            self.activityIn.isHidden = true
                            self.contactLabel.isHidden = false
                            self.stackViewIn.isUserInteractionEnabled = true
                            self.stackViewOut.isUserInteractionEnabled = true
                            if self.emailIn != "" {
                                self.appEmailLabel.text = self.emailIn
                                self.appEmailLabel.isHidden = false
                                self.emailInLogo.isHidden = false
                            }
                            else {
                                self.stackViewIn.isHidden = true
                            }
                            if self.emailOut != "" {
                                self.outEmailLabel.text = self.emailOut
                                self.outEmailLabel.isHidden = false
                                self.emailOutLogo.isHidden = false
                            }
                            else {
                                self.stackViewOut.isHidden = true
                            }
                        }
                    }
                    else {
                        self.errorCounter += 1
                        self.errorOccurred(errorCounter: self.errorCounter, url: url, type: 1)
                    }
                }
                else {
                    self.errorCounter += 1
                    self.errorOccurred(errorCounter: self.errorCounter, url: url, type: 1)
                }
            })
        }
        

    //    MARK: Get folder ID
    func getFolder(url: String) {
        network.getRequest(urlAsString: url, completionHandler: { success, statusCode, result in
            if !success {
                self.errorCounter += 1
                self.errorOccurred(errorCounter: self.errorCounter, url: url, type: 3)
            }
            else {
                if result != nil {
                    self.folderID = self.htmlParser.getFolderID(fromHtml: result!)
                }
                else {
                    self.errorCounter += 1
                    self.errorOccurred(errorCounter: self.errorCounter, url: url, type: 3)
                }
            }
        })
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
}
