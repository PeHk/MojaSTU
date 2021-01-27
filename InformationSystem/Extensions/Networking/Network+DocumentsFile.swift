//
//  Network+FileName.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 01/04/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation

extension Network {
//    MARK: Name of PDF
    func getNameOfFile(url: URL, completionHandler: @escaping (Bool, Int, String?) -> Void) {
        
        let group = DispatchGroup()
        let session = URLSession.shared
        let tokenToHeader = UserDefaults.standard.value(forKey: "tokenToHeader") as! String
        let tokenToValue = UserDefaults.standard.value(forKey: "tokenToValue") as! String
        
        var fileName = String()
        var request = URLRequest(url: url)
        
        group.enter()
        request.httpMethod = "GET"
        request.setValue(tokenToValue, forHTTPHeaderField: tokenToHeader)
        request.setValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36", forHTTPHeaderField: "User-Agent")
        request.setValue("sk", forHTTPHeaderField: "Content-Language")
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                let maybeName = httpResponse.allHeaderFields["Content-Disposition"]
                if maybeName != nil {
                    fileName = maybeName as! String
                    fileName = self.stringparser.suffixWithoutVal(value: "\"", string: fileName)
                    fileName = self.stringparser.prefixWithoutVal(value: "\"", string: fileName)
                    completionHandler(true, httpResponse.statusCode, fileName)
                }
                else {
                    completionHandler(false, httpResponse.statusCode, nil)
                }
            }
            else {
                completionHandler(false, 0, nil)
            }
            group.leave()
        }
        task.resume()
        group.wait()
    }
    
//    MARK: Download file
    func postFile(url: String, completion: @escaping (URL?, Int, Bool) -> Void ) {
        let group = DispatchGroup()
        let downloadURL = URL(string: url)
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        var fileName = String()
        
        getNameOfFile(url: downloadURL!, completionHandler: { success, statusCode, result in
            if success {
                if result != nil {
                    fileName = result!
                }
                else {
                    completion(nil, 0, false)
                }
            }
            else {
                completion(nil, 0, false)
            }
        })
    
        group.enter()
        let destinationFileUrl = documentsUrl.appendingPathComponent("\(fileName)")
        
        if FileManager().fileExists(atPath: destinationFileUrl.path)
        {
            print("File already exists [\(destinationFileUrl.path)]")
            completion(destinationFileUrl, 200, true)
        }
        else {
            
            let fileURL = URL(string: url)
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            let request = URLRequest(url:fileURL!)
            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    // Success
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        print("Successfully downloaded. Status code: \(statusCode)")
                    }
                    do {
                        try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                        completion(destinationFileUrl, 200, true)
                    }
                    catch (let writeError) {
                        print("Error creating a file \(destinationFileUrl) : \(writeError)")
                        completion(nil, 0, false)
                    }
                } else {
                    print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
                    completion(nil, 0, false)
                }
                group.leave()
            }
            task.resume()
            group.wait()
        }
    }
    
//    MARK: Download file with name
    func postFileWithName(url: String, fileName: String, completion: @escaping (URL?, Int, Bool) -> Void ) {
        let group = DispatchGroup()
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        group.enter()
        let destinationFileUrl = documentsUrl.appendingPathComponent("\(fileName)")
        
        if FileManager().fileExists(atPath: destinationFileUrl.path)
        {
            print("File already exists [\(destinationFileUrl.path)]")
            completion(destinationFileUrl, 200, true)
        }
        else {
            
            let fileURL = URL(string: url)
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            let request = URLRequest(url:fileURL!)
            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                if let tempLocalUrl = tempLocalUrl, error == nil {
                    // Success
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        print("Successfully downloaded. Status code: \(statusCode)")
                    }
                    do {
                        try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                        completion(destinationFileUrl, 200, true)
                    }
                    catch (let writeError) {
                        print("Error creating a file \(destinationFileUrl) : \(writeError)")
                        completion(nil, 0, false)
                    }
                } else {
                    print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
                    completion(nil, 0, false)
                }
                group.leave()
            }
            task.resume()
            group.wait()
        }
    }

}
