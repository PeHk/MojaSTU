//
//  URLsManager+CatchingRedirect.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 01/01/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation

extension Network {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(nil)
    }
}
