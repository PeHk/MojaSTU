//
//  NotificationsName+Extensions.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 10/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
import Foundation

extension Notification.Name {
    static let darkModeEnabled = Notification.Name("com.InformationSystem.notifications.darkModeEnabled")
    static let darkModeDisabled = Notification.Name("com.InformationSystem.notifications.darkModeDisabled")
    static let messageWasSent = Notification.Name("com.InformationSystem.notifications.messageWasSent")
    static let messageWasNotSent = Notification.Name("com.InformationSystem.notifications.messageWasNotSent")
    static let passwordChanged = Notification.Name("com.InformationSystem.notification.passwordChanged")
    static let mailboxChanged = Notification.Name("com.InformationSystem.notification.mailboxChanged")
    static let dateChanged = Notification.Name("com.InformationSystem.notification.dateChanged")
    static let checkEmailsCount = Notification.Name("com.InformationSystem.notification.checkEmailsCount")
    static let languageSlovak = Notification.Name("com.InformationSystem.notification.languageSlovak")
    static let languageEnglish = Notification.Name("com.InformationSystem.notification.languageEnglish")
}
