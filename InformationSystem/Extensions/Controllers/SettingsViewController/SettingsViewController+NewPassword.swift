//
//  SettingsViewController+NewPassword.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 31/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for handling new password request.

import Foundation
import Firebase

extension SettingsViewController {
//    MARK: Request
    func getSerialCode() {
        var serialCode : String? = nil
        network.getRequest(urlAsString: "https://is.stuba.sk/auth/wifi/heslo_vpn_sit.pl?lang=sk", completionHandler: { success, statusCode, result in
            if success {
                if result != nil {
                    serialCode = self.htmlparser.getSerialCodeWifi(fromHtml: result!)
                    if serialCode != nil {
                        let data = "lang=sk&zalozka=4&Pregenerovat=Pregenerovať heslo&serial=\(serialCode!)"
                        self.sendRequest(data: data)
                    }
                    else {
                        Analytics.logEvent("error_wifiPasswordChanged", parameters: ["statusCode": statusCode])
                        self.showErrorWindow()
                    }
                }
                else {
                    Analytics.logEvent("error_wifiPasswordChanged", parameters: ["statusCode": statusCode])
                    self.showErrorWindow()
                }
            }
            else {
                Analytics.logEvent("error_wifiPasswordChanged", parameters: ["statusCode": statusCode])
                self.showErrorWindow()
            }
        })
    }
//    MARK: Result
    func sendRequest(data: String) {
        DispatchQueue.global().async {
            self.network.postRequest(urlAsString: "https://is.stuba.sk/auth/wifi/heslo_vpn_sit.pl?lang=sk", dataToBody: data, completionHandler: { success, statusCode, result in
                if success {
                    if result != nil {
                        let password = self.htmlparser.getNewPassword(html: result!)
                        if password != nil {
                            self.setNotification(password: password!)
                            UserDefaults.standard.removeObject(forKey: "WifiPassword")
                            DispatchQueue.main.async {
                                Analytics.logEvent("wifiPasswordChanged", parameters: nil)
                                self.indicator.stopAnimating()
                                self.showAlertWindow(title: "Úspešne zmenené!", message: "Heslo bolo úspešne pregenerované!")
                                NotificationCenter.default.post(name: .passwordChanged, object: nil)
                            }
                        }
                    }
                }
                else {
                    Analytics.logEvent("error_wifiPasswordChanged", parameters: ["statusCode": statusCode])
                    self.showErrorWindow()
                }
            })
        }
    }
//    MARK: Alert
    func showErrorWindow() {
        DispatchQueue.main.async {
            self.showAlertWindow(title: "Chyba!", message: "Nastala nečakaná chyba! Heslo nebolo pregenerované!")
        }
    }
//    MARK: Notification
    func setNotification(password: String) -> Void {
        let manager = LocalNotificationManager()
        manager.requestPermission()
        manager.addNotification(title: "Vygenerované nové heslo", body:"Nové heslo do univerzitnej siete: \(password)")
        manager.scheduleNotifications()
    }
}
