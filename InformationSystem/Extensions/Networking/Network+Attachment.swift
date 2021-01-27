//
//  Network+Attachment.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 01/04/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation

extension Network {
//    MARK: Download attachment
    func postAttachment(url: String, fileName: String, completion: @escaping (URL?, Int, Bool) -> Void ) {
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
