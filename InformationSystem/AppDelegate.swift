//
//  AppDelegate.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 30/10/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import Firebase
import CoreLocation
import SwiftKeychainWrapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let gcmMessageIDKey = "gcm.message_id"
    var isError = false
    let locationManager = CLLocationManager()
    
    //    MARK: Did finish launching
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        locationManager.delegate = self
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        
        application.registerForRemoteNotifications()
        
        let emailType = Int.random(in: 0..<3)
        print(emailType)
        
        if (UserDefaults.standard.object(forKey: "emailControlDisabled") == nil) {
            if emailType == 0 {
                Messaging.messaging().subscribe(toTopic: "emails1") { error in
                    print("Subscribed to emails1")
                }
                Messaging.messaging().unsubscribe(fromTopic: "emails2")
                Messaging.messaging().unsubscribe(fromTopic: "emails3")
            } else if emailType == 1 {
                Messaging.messaging().subscribe(toTopic: "emails2") { error in
                    print("Subscribed to emails2")
                }
                Messaging.messaging().unsubscribe(fromTopic: "emails1")
                Messaging.messaging().unsubscribe(fromTopic: "emails3")
            } else if emailType == 2 {
                Messaging.messaging().subscribe(toTopic: "emails3") { error in
                    print("Subscribed to emails3")
                }
                Messaging.messaging().unsubscribe(fromTopic: "emails1")
                Messaging.messaging().unsubscribe(fromTopic: "emails2")
            }
            
        } else {
            let isControlEnabled = UserDefaults.standard.bool(forKey: "emailControlDisabled")
            if !isControlEnabled {
                if emailType == 0 {
                    Messaging.messaging().subscribe(toTopic: "emails1") { error in
                        print("Subscribed to emails1")
                    }
                    Messaging.messaging().unsubscribe(fromTopic: "emails2")
                    Messaging.messaging().unsubscribe(fromTopic: "emails3")
                } else if emailType == 1 {
                    Messaging.messaging().subscribe(toTopic: "emails2") { error in
                        print("Subscribed to emails2")
                    }
                    Messaging.messaging().unsubscribe(fromTopic: "emails1")
                    Messaging.messaging().unsubscribe(fromTopic: "emails3")
                } else if emailType == 2 {
                    Messaging.messaging().subscribe(toTopic: "emails3") { error in
                        print("Subscribed to emails3")
                    }
                    Messaging.messaging().unsubscribe(fromTopic: "emails1")
                    Messaging.messaging().unsubscribe(fromTopic: "emails2")
                }
            }
        }
        
        
        
        let isAutomaticMode = UserDefaults.standard.bool(forKey: "automaticModeEnabled")
        if isAutomaticMode {
            retriveCurrentLocation()
        }
        return true
    }
    
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        UIApplication.shared.applicationIconBadgeNumber = 0
//    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
//         Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        guard (userInfo["aps"] as? [String?: Any]) != nil else {
            Analytics.logEvent("fetch_failed", parameters: nil)
            completionHandler(.failed)
            return
        }
        
        if (UserDefaults.standard.object(forKey: "emailControlDisabled") != nil) {
            let isControlEnabled = UserDefaults.standard.bool(forKey: "emailControlDisabled")
            if isControlEnabled {
                completionHandler(.failed)
                return
            }
        }
        
        let delay = Double.random(min: 0.0, max: 25.0)
        print(delay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let login = KeychainWrapper.standard.string(forKey: "name")
            let password = KeychainWrapper.standard.string(forKey: "pass")
            
            print("Going ahead")
            
            if login != nil && password != nil {
                let session = URLSession.shared
                let url = URL(string: "https://is.stuba.sk/system/login.pl")!
                let body_values = Data(("lang=sk&login_hidden=1&destination=%2Fauth%2F%3Flang%3Dsk&auth_id_hidden=0&auth_2fa_type=no&credential_0=\(login!)&credential_1=\(password!)&credential_k=&credential_2=86400").utf8)
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36", forHTTPHeaderField: "User-Agent")
                request.httpBody = body_values
                
                print("Starting load data")
                
                let loadDataTask = session.downloadTask(with: request) { data, response, error in
                    if let httpResponse = response as? HTTPURLResponse {
                        print(httpResponse.statusCode)
                        if httpResponse.statusCode == 200 {
                            if let data = data {
                                if let dataString = try? String(contentsOf: data) {
                                    let htmlparser: HTMLParser = HTMLParser()
                                    let numberOfEmails = htmlparser.getXPathvalue(xPath: "/html/body/div[1]/div[3]/div[3]/a[1]", fromHtml: dataString)
                                    let oldNumber: String
                                    if UserDefaults.standard.value(forKey: "countOfEmails") ?? nil != nil {
                                        oldNumber = UserDefaults.standard.value(forKey: "countOfEmails") as! String
                                    } else {
                                        oldNumber = "0"
                                    }
                                    
                                    if (Int(numberOfEmails) ?? 0 > 0) && (Int(oldNumber) != Int(numberOfEmails)) {
                                        UserDefaults.standard.set(numberOfEmails, forKey: "countOfEmails")
                                        
//                                        TODO: Set tab badge, set refresh on page
                                        UserDefaults.standard.set(true, forKey: "email_refresh")
                                    
                                        
                                        if (numberOfEmails == "1") {
                                            self.setNotification(title: "Psst.. 🤫 V schránke máš nové správy 📬", body: "\(numberOfEmails) neprečítaná správa")
                                        } else if numberOfEmails == "2" || numberOfEmails == "3" || numberOfEmails == "4" {
                                            self.setNotification(title: "Psst.. 🤫 V schránke máš nové správy 📬", body: "\(numberOfEmails) neprečítané správy")
                                        } else {
                                            self.setNotification(title: "Psst.. 🤫 V schránke máš nové správy 📬", body: "\(numberOfEmails) neprečítaných správ")
                                        }
                                        
                                    }
                                    DispatchQueue.main.async {
                                        application.applicationIconBadgeNumber = Int(numberOfEmails) ?? 0
                                    }
                                    completionHandler(.newData)
                                } else {
                                    completionHandler(.failed)
                                }
                            }
                            else {
                                completionHandler(.failed)
                            }
                        }
                        else {
                            completionHandler(.failed)
                        }
                    }
                    else {
                        completionHandler(.failed)
                    }
                }
                loadDataTask.resume()
            }
            else {
                completionHandler(.failed)
            }
        }
    }
        
    func setNotification(title: String, body: String) -> Void {
        let manager = LocalNotificationManager()
        manager.addNotification(title: title, body: body)
        manager.requestPermission()
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
}
