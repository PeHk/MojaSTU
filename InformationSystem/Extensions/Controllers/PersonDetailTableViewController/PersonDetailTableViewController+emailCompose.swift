//
//  PersonDetailViewController+emailCompose.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 22/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

extension PersonDetailTableViewController: MFMailComposeViewControllerDelegate {
    
    func createEmailUrl(to: String) -> URL? {
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=&body=")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=&body=")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=&body=")
        let defaultUrl = URL(string: "mailto:\(to)?subject=&body=")

        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        else {
            showAlertWindow(title: "Chýba emailový klient!", message: "Nemáš žiadny aktívny emailový klient!")
        }

        return defaultUrl
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func showMessageComposer(recipientEmail: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])

            present(mail, animated: true)

        // Show third party email composer if default Mail app is not present
        } else if let emailUrl = createEmailUrl(to: recipientEmail) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
}
