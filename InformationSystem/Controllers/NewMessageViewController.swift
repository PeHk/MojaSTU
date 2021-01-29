//
//  NewMessageViewController.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 03/01/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class NewMessageViewController: UIViewController {

//    MARK: Outlets
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.setBottomBorder(withColor: UIColor.gray)
        }
    }
    @IBOutlet weak var subjectTextField: UITextField! {
        didSet {
            subjectTextField.setBottomBorder(withColor: UIColor.gray)
            subjectTextField.delegate = self
        }
    }
    
//    MARK: Variables
    var answerEmail = Email()
    var newEmail = Email()
    var isAnswer = false
    var folderID = String()
    var emailTo = String()
    var subject = String()
    var message = String()
    var personFinder = Bool()
    var recipient = String()
    var newMessageString = "Nová správa"
    var cancelString = "Zrušiť"
    var sendString = "Odoslať"
    var noRecipientTitle = "Nevyplnili ste príjemcu!"
    var noRecipientText = "Doplňte príjemcov správy a skúste znova."
    var conceptTitle = "Koncept"
    var conceptText = "Želáte si zahodiť rozpísanú správu?"
    var conceptCancel = "Zahodiť koncept"
    var incompleteTitle = "Nekompletná správa!"
    var incompleteText = "Chcete odoslať správu bez predmetu alebo textu v tele?"
    
//    MARK: Instances
    let network: Network = Network()
    let htmlparser: HTMLParser = HTMLParser()
    let stringparser: StringParser = StringParser()
    
//    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
        checkObservers()
    
        if personFinder {
            emailTextField.text = recipient
        }
        if !answerEmail.subject.isEmpty && !answerEmail.name.isEmpty {
            setAnswerEmail()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .languageSlovak, object: nil)
        NotificationCenter.default.removeObserver(self, name: .languageEnglish, object: nil)
    }
    
//    MARK: Send tapped
    @IBAction func sendTapped(_ sender: Any) {
        if !emailTextField.text!.isEmpty {
            message = messageTextView.text
            emailTo = emailTextField.text!
            subject = subjectTextField.text!
            
            if subjectTextField.text!.isEmpty || messageTextView.text.isEmpty {
                alertForEmail()
            }
            else {
                if !isAnswer {
                    sendNewEmail()
                }
                else {
                    sendAnsweringEmail()
                }
            }
        }
        else {
            showAlertWindow(title: self.noRecipientTitle, message: self.noRecipientText)
        }
    }
//    MARK: Cancel tapped
    @IBAction func cancelTapped(_ sender: Any) {
        if !subjectTextField.text!.isEmpty || !emailTextField.text!.isEmpty || !messageTextView.text.isEmpty {
            let alert = UIAlertController(title: self.conceptTitle, message: self.conceptText, preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: self.conceptCancel, style: UIAlertAction.Style.destructive, handler: { action in
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }))
//            alert.addAction(UIAlertAction(title: "Uložiť koncept", style: UIAlertAction.Style.default, handler: { action in
//                DispatchQueue.main.async {
//                    self.showAlertWindow(title: "Neimplementované!", message: "Funkcionalita nebola zatiaľ implementovaná!")
//                }
//            }))
            alert.addAction(UIAlertAction(title: self.cancelString, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
//    MARK: Background sending
    func sendNewEmail() {
        dismissEmail()
        DispatchQueue.global().async {
            self.sendNewMessage()
        }
    }
    
    func sendAnsweringEmail() {
        dismissEmail()
        DispatchQueue.global().async {
            self.sendAnswerMessage()
        }
    }

//    MARK: Alert window
    func alertForEmail() {
        let alert = UIAlertController(title: self.incompleteTitle, message: self.incompleteText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: self.sendString, style: .default, handler: { action in
            if !self.isAnswer {
                self.sendNewEmail()
            }
            else {
                self.sendAnsweringEmail()
            }
        }))
        alert.addAction(UIAlertAction(title: self.cancelString, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
//    MARK: Dismiss animation
    func dismissEmail() {
        self.dismiss(animated: false, completion: nil)
        let transition: CATransition = CATransition()
        transition.duration = 1.0
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromTop
        self.view.window!.layer.add(transition, forKey: nil)
        let systemSoundID: SystemSoundID = 1001
        AudioServicesPlaySystemSound (systemSoundID)
    }
    
//    MARK: Set answering email
    func setAnswerEmail() {
        emailTextField.text = answerEmail.name
        subjectTextField.text = answerEmail.subject
        titleTextField.text = answerEmail.subject
        messageTextView.text = "\n \n" + answerEmail.textOfEmail
        let newPosition = messageTextView.beginningOfDocument
        messageTextView.selectedTextRange = messageTextView.textRange(from: newPosition, to: newPosition)
        messageTextView.becomeFirstResponder()
    }
    
//    MARK: New message sending
    func sendNewMessage() {
        network.sendNewMessage(userSerialCode: newEmail.serialCode, emailTo: emailTo, subject: subject, textMessage: message, folderID: folderID, completionHandler: { success, statusCode in
            if !success {
                NotificationCenter.default.post(name: .messageWasNotSent, object: nil)
                Analytics.logEvent("error_NewMessage", parameters: ["statusCode": statusCode])
            }
            else {
                NotificationCenter.default.post(name: .messageWasSent, object: nil)
                Analytics.logEvent("message_NewMessageSent", parameters: nil)
            }
        })
    }
    
//    MARK: Answer message sending
    func sendAnswerMessage() {
        network.sendAnswerMessage(userSerialCode: answerEmail.serialCode, emailTo: emailTo, subject: subject, textMessage: message, folderID: folderID, eid: answerEmail.eid, fid: answerEmail.fid, old_eid: answerEmail.old_eid, old_fid: answerEmail.old_fid, completionHandler: { success, statusCode in
            if !success {
                NotificationCenter.default.post(name: .messageWasNotSent, object: nil)
                Analytics.logEvent("error_AnswerMessage", parameters: ["statusCode": statusCode])
            }
            else {
                NotificationCenter.default.post(name: .messageWasSent, object: nil)
                Analytics.logEvent("message_AnswerSent", parameters: nil)
            }
        })
    }
}
