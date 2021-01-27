//
//  URLsManager.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 14/11/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

/*
// MARK: - Info

// In this class we can control all the GET and POST request to the AIS server.
*/

import Foundation
import SwiftKeychainWrapper

class Network: NSObject, URLSessionDelegate, URLSessionTaskDelegate {
        
//    MARK: Constructors
    let stringparser : StringParser = StringParser()
    
    
//    MARK: Login authentication
    /*In this function we send username and password to server, when user exist in database, server return 302 (moved)
     with login token which is used to access data in server. If error occured, server return 200, in this case, function
     completion handler is set to false and managed in controller*/
    func authenticationLogin(login: String, password: String, noRedirect: Bool, completionHandler: @escaping (Int, Bool) -> Void) {
        let group = DispatchGroup()
        let url = URL(string: "https://is.stuba.sk/system/login.pl")!
        let body_values = Data(("lang=sk&login_hidden=1&destination=%2Fauth%2F%3Flang%3Dsk&auth_id_hidden=0&auth_2fa_type=no&credential_0=\(login)&credential_1=\(password)&credential_k=&credential_2=86400").utf8)
        
        var statusCode = Int()
        var request = URLRequest(url: url)
        var token = String()
        var tokenToValue = String()
        var tokenToHeader = String()
        
        group.enter()
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36", forHTTPHeaderField: "User-Agent" )
    
        let myDelegate: Network? = noRedirect ? Network() : nil
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: myDelegate, delegateQueue: nil)
        let loadDataTask = session.uploadTask(with: request, from: body_values) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
                if httpResponse.statusCode == 302 {
                    token = httpResponse.value(forHTTPHeaderField: "Set-Cookie") ?? ""
                    if !token.isEmpty {
                        token = self.stringparser.prefixWithoutVal(value: ";", string: token)
                        tokenToValue = self.stringparser.prefixWithVal(value: "=", string: token)
                        tokenToHeader = self.stringparser.suffixWithoutVal(value: "=", string: token)
                        UserDefaults.standard.set(tokenToHeader, forKey: "tokenToHeader")
                        UserDefaults.standard.set(tokenToValue, forKey: "tokenToValue")
                        completionHandler(statusCode, true)
                    }
                }
                else {
                    completionHandler(statusCode, false)
                }
            }
            else {
                 completionHandler(statusCode, false)
            }
            group.leave()
        }
        loadDataTask.resume()
        group.wait()
    }
    
//  MARK: Post on new token
    func getNewToken(noRedirect: Bool, completionHandler: @escaping (Int, Bool) -> Void) {
        let group = DispatchGroup()
        let login = KeychainWrapper.standard.string(forKey: "name")!
        let password = KeychainWrapper.standard.string(forKey: "pass")!
        let url = URL(string: "https://is.stuba.sk/system/login.pl")!
        let body_values = Data(("lang=sk&login_hidden=1&destination=%2Fauth%2F%3Flang%3Dsk&auth_id_hidden=0&auth_2fa_type=no&credential_0=\(login)&credential_1=\(password)&credential_k=&credential_2=86400").utf8)
        
        var statusCode = Int()
        var request = URLRequest(url: url)
        var token = String()
        var tokenToValue = String()
        var tokenToHeader = String()
        
        group.enter()
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36", forHTTPHeaderField: "User-Agent" )
    
        let myDelegate: Network? = noRedirect ? Network() : nil
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: myDelegate, delegateQueue: nil)
        let loadDataTask = session.uploadTask(with: request, from: body_values) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
                if httpResponse.statusCode == 302 {
                    token = httpResponse.value(forHTTPHeaderField: "Set-Cookie") ?? ""
                    if !token.isEmpty {
                        token = self.stringparser.prefixWithoutVal(value: ";", string: token)
                        tokenToValue = self.stringparser.prefixWithVal(value: "=", string: token)
                        tokenToHeader = self.stringparser.suffixWithoutVal(value: "=", string: token)
                        UserDefaults.standard.set(tokenToHeader, forKey: "tokenToHeader")
                        UserDefaults.standard.set(tokenToValue, forKey: "tokenToValue")
                        completionHandler(statusCode, true)
                    }
                }
                else {
                    completionHandler(statusCode, false)
                }
            }
            else {
                completionHandler(statusCode, false)
            }
            group.leave()
        }
        loadDataTask.resume()
        group.wait()
    }
    
//    MARK: Get request
    func getRequest(urlAsString: String, completionHandler: @escaping (Bool, Int, String?) -> Void) {
        let group = DispatchGroup()
        let session = URLSession.shared
        let url = URL(string: urlAsString)!
        guard let tokenToHeader = UserDefaults.standard.value(forKey: "tokenToHeader") as? String else {
            completionHandler(false, 403, nil)
            return
        }
        guard let tokenToValue = UserDefaults.standard.value(forKey: "tokenToValue") as? String else {
            completionHandler(false, 403, nil)
            return
        }
        
        var request = URLRequest(url: url)
        var statusCode = Int()
        
        group.enter()
        request.httpMethod = "GET"
        request.setValue(tokenToValue, forHTTPHeaderField: tokenToHeader)
        request.setValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36", forHTTPHeaderField: "User-Agent")
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
                if httpResponse.statusCode == 200 {
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        completionHandler(true, statusCode, dataString)
                    }
                }
                else {
                    completionHandler(false, statusCode, nil)
                }
            }
            else {
                completionHandler(false, statusCode, nil)
            }
            group.leave()
        }
        task.resume()
        group.wait()
    }
//    MARK: Post request
    func postRequest(urlAsString: String, dataToBody: String, completionHandler: @escaping (Bool, Int, String?) -> Void) {
        let group = DispatchGroup()
        let session = URLSession.shared
        let url = URL(string: urlAsString)!
        let tokenToHeader = UserDefaults.standard.value(forKey: "tokenToHeader") as! String
        let tokenToValue = UserDefaults.standard.value(forKey: "tokenToValue") as! String
        
        var request = URLRequest(url: url)
        var statusCode = Int()
        
        group.enter()
        request.httpMethod = "POST"
        request.setValue(tokenToValue, forHTTPHeaderField: tokenToHeader)
        request.setValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36", forHTTPHeaderField: "User-Agent")
        request.setValue("sk", forHTTPHeaderField: "Content-Language")
        
        let body_values = Data(dataToBody.utf8)
        let loadDataTask = session.uploadTask(with: request, from: body_values) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
                if httpResponse.statusCode == 200 {
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        completionHandler(true, statusCode, dataString)
                    }
                }
                else {
                    completionHandler(false, statusCode, nil)
                }
            }
            else {
                completionHandler(false, statusCode, nil)
            }
            group.leave()
        }
        loadDataTask.resume()
        group.wait()
    }
//    MARK: Get JSON request
    func getJSON(urlAsString: String, completionHandler: @escaping (Bool, Int, String?) -> Void) {
       
        let group = DispatchGroup()
        let session = URLSession.shared
        let url = URL(string: urlAsString)!
        let tokenToHeader = UserDefaults.standard.value(forKey: "tokenToHeader") as! String
        let tokenToValue = UserDefaults.standard.value(forKey: "tokenToValue") as! String
        
        var statusCode = Int()
        var request = URLRequest(url: url)
        
        group.enter()
        
        request.httpMethod = "GET"
    
        request.setValue(tokenToValue, forHTTPHeaderField: tokenToHeader)
        request.setValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36", forHTTPHeaderField: "User-Agent")
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
                if httpResponse.statusCode == 200 {
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        completionHandler(true, statusCode, dataString)
                    }
                }
                else {
                     completionHandler(false, statusCode, nil)
                }
            }
            else {
                completionHandler(false, statusCode, nil)
            }
            group.leave()
        }
        task.resume()
        group.wait()
    }
//    MARK: Get request to Data
    func getData(urlAsString: String, completionHandler: @escaping (Bool, Data?) -> Void) {
        let group = DispatchGroup()
        let tokenToHeader = UserDefaults.standard.value(forKey: "tokenToHeader") as! String
        let tokenToValue = UserDefaults.standard.value(forKey: "tokenToValue") as! String
        let session = URLSession.shared
        let url = URL(string: urlAsString)!

        var request = URLRequest(url: url)
        
        group.enter()
        
        request.httpMethod = "GET"
        request.setValue(tokenToValue, forHTTPHeaderField: tokenToHeader)
        request.setValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36", forHTTPHeaderField: "User-Agent")

        let task = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                completionHandler(true, data)
            }
            else {
                completionHandler(false, nil)
            }
            group.leave()
        }
        task.resume()
        group.wait()
    }


    
    
    
 
//    MARK: GET Data Request
    func sendGETData(tokenToHeader: String, tokenToValue: String, urlAsString: String) -> Data {
        let group = DispatchGroup()
        group.enter()

        let session = URLSession.shared
        let url = URL(string: urlAsString)!

        var HTMLAnswer = Data()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.setValue(tokenToValue, forHTTPHeaderField: tokenToHeader)
        request.setValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36", forHTTPHeaderField: "User-Agent")
        request.setValue("sk", forHTTPHeaderField: "Content-Language")

        let task = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                HTMLAnswer = data
            }
            group.leave()
        }
        task.resume()
        group.wait()

        return HTMLAnswer
    }
}
