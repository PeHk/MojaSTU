//
//  Network+Emails.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 01/04/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
extension Network {
//    MARK: Post in new message
    func sendNewMessage(userSerialCode: String, emailTo: String, subject: String, textMessage: String, folderID: String, completionHandler: @escaping (Bool, Int) -> Void) {
        
        let url = URL(string: "https://is.stuba.sk/auth/posta/nova_zprava.pl?lang=sk")
        let tokenToHeader = UserDefaults.standard.value(forKey: "tokenToHeader") as! String
        let tokenToValue = UserDefaults.standard.value(forKey: "tokenToValue") as! String
        
        var statusCode = Int()
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(tokenToValue, forHTTPHeaderField: tokenToHeader)
        request.setValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36", forHTTPHeaderField: "User-Agent")
        
        let data = Data(("lang=sk&zprava=1&To=\(emailTo)&Cc=&Bcc=&Subject=\(subject)&Data=\(textMessage)&priloha=&priloha=&priloha=&priloha=&priloha=&priloha=&priloha=&ulozit_odesl_zpravu=1&ulozit_do_sl=\(folderID)&send=ODOSLAŤ SPRÁVU&akce=schranka&serializace=\(userSerialCode)").utf8)
        
        let noRedirect = true
        let myDelegate: Network? = noRedirect ? Network() : nil
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: myDelegate, delegateQueue: nil)
        let loadDataTask = session.uploadTask(with: request, from: data) { (responseData, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
                if httpResponse.statusCode == 302 {
                    completionHandler(true, statusCode)
                }
                else {
                    completionHandler(false, statusCode)
                }
            }
            else {
                completionHandler(false, statusCode)
            }
        }
        loadDataTask.resume()
    }
    
//    MARK: Post in answer message
    func sendAnswerMessage (userSerialCode: String, emailTo: String, subject: String, textMessage: String, folderID: String, eid: String, fid: String, old_eid: String, old_fid: String
        , completionHandler: @escaping (Bool, Int) -> Void) {
        
        let group = DispatchGroup()
        let url = URL(string: "https://is.stuba.sk/auth/posta/nova_zprava.pl?lang=sk")
        let tokenToHeader = UserDefaults.standard.value(forKey: "tokenToHeader") as! String
        let tokenToValue = UserDefaults.standard.value(forKey: "tokenToValue") as! String
        
        var statusCode = Int()
        var request = URLRequest(url: url!)
        
        group.enter()
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(tokenToValue, forHTTPHeaderField: tokenToHeader)
        request.setValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36", forHTTPHeaderField: "User-Agent")
        
        let data = Data(("lang=sk&zprava=1&To=\(emailTo)&Cc=&Bcc=&Subject=\(subject)&Data=\(textMessage)&priloha=&priloha=&priloha=&priloha=&priloha=&priloha=&priloha=&ulozit_odesl_zpravu=1&ulozit_do_sl=\(folderID)&send=ODOSLAŤ SPRÁVU&akce=schranka&serializace=\(userSerialCode)&old_fid=\(old_fid)&old_eid=\(old_eid)&fid=\(fid)&eid=\(eid)&menu_akce=odpovedet").utf8)
        
        let noRedirect = true
        let myDelegate: Network? = noRedirect ? Network() : nil
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: myDelegate, delegateQueue: nil)
        let loadDataTask = session.uploadTask(with: request, from: data) { (responseData, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
                if httpResponse.statusCode == 302 {
                    completionHandler(true, statusCode)
                }
                else {
                    completionHandler(false, statusCode)
                }
            }
            else {
                completionHandler(false, statusCode)
            }
            group.leave()
        }
        loadDataTask.resume()
        group.wait()
    }
}
