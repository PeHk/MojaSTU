//
//  UIViewController+Badge.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 24/01/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setBadge(html: String) {
        
        let htmlparser: HTMLParser = HTMLParser()
        let numberOfNotifications = htmlparser.getXPathvalue(xPath: "/html/body/div[1]/div[3]/div[3]/a[1]", fromHtml: html)
        let userDefaults: String
        if (UserDefaults.standard.value(forKey: "countOfEmails") ?? nil != nil) {
            userDefaults = UserDefaults.standard.value(forKey: "countOfEmails") as! String
            if (numberOfNotifications != userDefaults) {
                UserDefaults.standard.set(numberOfNotifications, forKey: "countOfEmails")
            }
        }
        
        let tabItems = self.tabBarController?.tabBar.items as NSArray?
        let selectedIndex = 1
        let tabItem = tabItems![selectedIndex] as! UITabBarItem
        
        if numberOfNotifications == "0" {
            tabItem.badgeValue = nil
        }
        else {
            tabItem.badgeValue = numberOfNotifications
        }
    }
    
    func setBadgeDirectly() {
        let number = UserDefaults.standard.value(forKey: "countOfEmails") as? String
        if number != nil {
            let tabItems = self.tabBarController?.tabBar.items as NSArray?
            let selectedIndex = 1
            let tabItem = tabItems![selectedIndex] as! UITabBarItem
            
            if number! == "0" {
                tabItem.badgeValue = nil
            }
            else {
                tabItem.badgeValue = number!
            }
        }
        
    }
    
    func initialBadge() {
        var HTML = String()
        let htmlparser: HTMLParser = HTMLParser()
        let url = "https://is.stuba.sk/auth/?lang=sk"
        
        do {
            HTML = sendBadge(urlAsString: url)
            if HTML == "Forbidden" || HTML == "Error" {
                print("New token needed!")
                requestForNewToken()
                initialBadge()
            }
            else {
                let numberOfNotifications = htmlparser.getXPathvalue(xPath: "/html/body/div[1]/div[3]/div[3]/a[1]", fromHtml: HTML)
                let tabItems = self.tabBarController?.tabBar.items as NSArray?
                let selectedIndex = 1
                let tabItem = tabItems![selectedIndex] as! UITabBarItem
                
                if numberOfNotifications == "0" {
                    tabItem.badgeValue = nil
                }
                else {
                    tabItem.badgeValue = numberOfNotifications
                }
            }
        }
    }
    
    func sendBadge(urlAsString: String) -> String {
        let group = DispatchGroup()
        let session = URLSession.shared
        let url = URL(string: urlAsString)!
        let tokenToHeader = UserDefaults.standard.value(forKey: "tokenToHeader") as! String
        let tokenToValue = UserDefaults.standard.value(forKey: "tokenToValue") as! String
        
        var HTMLAnswer = String()
        var request = URLRequest(url: url)
        
        group.enter()
        request.httpMethod = "GET"
        request.setValue(tokenToValue, forHTTPHeaderField: tokenToHeader)
        request.setValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36", forHTTPHeaderField: "User-Agent")
        request.setValue("sk-SK,sk;q=0.9", forHTTPHeaderField: "Accept-Language")
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 403 {
                    HTMLAnswer = "Forbidden"
                }
                else if httpResponse.statusCode == 200 {
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        HTMLAnswer = dataString
                    }
                }
                else {
                    HTMLAnswer = "Error"
                }
            }
            group.leave()
        }
        task.resume()
        group.wait()
        
        return HTMLAnswer
    }
}
