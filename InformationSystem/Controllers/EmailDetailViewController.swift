//
//  EmailDetailViewController.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 23/01/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import UIKit
import Firebase

class EmailDetailViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
//    MARK: Outlets
    @IBOutlet weak var circleView: UIView! {
        didSet{
            circleView.layer.cornerRadius = (circleView.frame.height) / 2
            circleView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var circleLabel: UILabel! {
        didSet {
            circleLabel.text = emailObject.name.getAcronym(name: emailObject.name)
        }
    }
    @IBOutlet weak var subjectName: UILabel! {
        didSet {
            subjectName.text = emailObject.subject
            subjectName.font = UIFont.preferredFont(forTextStyle: .headline)
            subjectName.adjustsFontForContentSizeCategory = true
        }
    }
    @IBOutlet weak var senderName: UILabel! {
        didSet {
            senderName.text = emailObject.name
        }
    }
    @IBOutlet weak var emailText: UITextView! {
        didSet {
            emailText.delegate = self
            emailText.textContainerInset = UIEdgeInsets(top: 15,left: 0,bottom: 0,right: 10)
        }
    }
    @IBOutlet weak var borderView: UIView! {
        didSet {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(answer))
        }
    }
    @IBOutlet weak var unreadMarkView: UIView! {
        didSet {
            unreadMarkView.layer.cornerRadius = (unreadMarkView.frame.height) / 2
            unreadMarkView.isHidden = true
        }
    }
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.text = emailObject.time
        }
    }
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.text = emailObject.date
        }
    }
    @IBOutlet weak var showAttachment: UIView! {
        didSet {
//            showAttachment.layer.cornerRadius = showAttachment.frame.height / 2
            let tap = UITapGestureRecognizer(target: self, action: #selector(attachmentTapped))
            showAttachment.addGestureRecognizer(tap)
            showAttachment.isHidden = true
            showAttachment.layer.shadowColor = UIColor.black.cgColor
            showAttachment.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            showAttachment.layer.masksToBounds = false
            showAttachment.layer.shadowRadius = 1.0
            showAttachment.layer.shadowOpacity = 0.5
            showAttachment.layer.cornerRadius = showAttachment.frame.width / 2
        }
    }
//    MARK: Variables
    var emailObject = Email()
    var answerEmailObject = Email()
    var HTML = String()
    var detailURL = "https://is.stuba.sk/auth/posta"
    var answerEmail = "https://is.stuba.sk/auth/posta"
    var textOfMessage = String()
    var errorCounter = 0
    var indicator = UIActivityIndicatorView()
    var attachmentsArray : [Attachment]?
    var errorTitle = "Nastala chyba, skontrolujte si internetové pripojenie alebo prihlasovacie údaje!"
    var errorMessageFirst = "Počet pokusov na pripojenie: "
    var errorMessageLast = "Tlačidlom zrušiť zavriete aplikáciu!"
    var cancelString = "Zrušiť"
    var alertTitle = "Niečo sa pokazilo!"
    var alertText = "Prosím reštartujte aplikáciu!"
    
//    MARK: Instances
    let network: Network = Network()
    let htmlparser: HTMLParser = HTMLParser()
    let stringparser: StringParser = StringParser()
    
//    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
        checkObservers()
        indicator.startAnimating()
        
        NotificationCenter.default.addObserver(self, selector: #selector(messageWasSent(_:)), name: .messageWasSent, object: nil)

        if emailObject.unread {
            unreadMarkView.isHidden = false
            emailObject.unread = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.hideUnreadMark()
            }
        }
    
        detailURL = detailURL + emailObject.httpLink
        answerEmail = answerEmail + emailObject.httpLink
        answerEmail = answerEmail.replacingOccurrences(of: "email", with: "nova_zprava")
        answerEmail = answerEmail + ";menu_akce=odpovedet"
        
        DispatchQueue.global().async {
            self.getEmailDetail(url: self.detailURL)
            if !self.HTML.isEmpty {
                let HTMLDetail = self.HTML
                
                DispatchQueue.main.async {
                    self.setBadge(html: HTMLDetail)
                    self.indicator.stopAnimating()
                    (self.textOfMessage, self.attachmentsArray) = self.htmlparser.parseMessage(fromHtml: HTMLDetail)
                    if self.attachmentsArray != nil {
                        if self.attachmentsArray!.count > 0 {
                            self.showAttachmentView()
                        }
                    }
                    self.setTextOfMessage()
                }
                
                self.getEmailDetail(url: self.answerEmail)
                if !self.HTML.isEmpty {
                    let htmlAnswer = self.HTML
                    self.answerEmailObject = self.htmlparser.getAnswerEmail(fromHtml: htmlAnswer)
                }
                else {
                    DispatchQueue.main.async {
                        self.showAlertWindow(title: self.alertTitle, message: self.alertText)
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    self.showAlertWindow(title: self.alertTitle, message: self.alertText)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Analytics.logEvent("emailDetailLoaded", parameters: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .messageWasSent, object: nil)
        NotificationCenter.default.removeObserver(self, name: .languageSlovak, object: nil)
        NotificationCenter.default.removeObserver(self, name: .languageEnglish, object: nil)
    }
    
//      MARK: Notification
    @IBAction func messageWasSent(_ notification: Notification) {
        DispatchQueue.main.async {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }

    
//      MARK: Answer button
    @objc func answer() {
        let storyboard = UIStoryboard(name: "MailClient", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "NewMessageController") as! NewMessageViewController
        vc.answerEmail = answerEmailObject
        vc.isAnswer = true
        self.present(vc, animated: true, completion: nil)
    }
    
    func hideUnreadMark() {
        unreadMarkView.isHidden = true
    }
    
//    MARK: Setting the text of message
    func setTextOfMessage() {
        DispatchQueue.main.async {
            self.emailText.text = self.textOfMessage
            
            let isDarkMode = UserDefaults.standard.bool(forKey: "darkModeEnabled")
            if isDarkMode {
                self.emailText.backgroundColor = .black
                self.emailText.textColor = .white
            }
            else {
                self.emailText.backgroundColor = .white
                self.emailText.textColor = .black
            }
        }
    }
    
//     MARK: Error occurred
    func errorOccurred(errorCounter: Int, url: String) {
        if errorCounter <= 3 {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: self.errorTitle, message: self.errorMessageFirst + "\(3 - errorCounter). " + self.errorMessageLast, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: self.cancelString, style: .destructive, handler: { action in
                    exit(0)
                }))
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                    self.requestForNewToken()
                    self.getEmailDetail(url: url)
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
    
//     MARK: Get on email detail
    func getEmailDetail(url: String) {
        network.getRequest(urlAsString: url, completionHandler: { success, statusCode, result in
            if !success {
                Analytics.logEvent("error_emailDetail", parameters: ["statusCode": statusCode])
                self.errorCounter += 1
                self.errorOccurred(errorCounter: self.errorCounter, url: url)
            }
            else {
                if result != nil {
                    self.HTML = result!
                }
            }
        })
    }
}
