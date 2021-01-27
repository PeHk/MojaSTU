//
//  AppDelegate+MessagingDelegate.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 26/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import Firebase
import UIKit

extension AppDelegate : MessagingDelegate {
  // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")
    
    let dataDict:[String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
  }
  
//  func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//    print("Received data message: \(remoteMessage.appData)")
//  }
}
