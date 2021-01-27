//
//  UIViewController+NewTokenRequest.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 02/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func requestForNewToken() {
        let network: Network = Network()
        network.getNewToken(noRedirect: true, completionHandler: {statusCode, success in
//            if !success {
//                DispatchQueue.main.async {
//                    self.resetDefaults()
//                    let sb = UIStoryboard(name: "Main", bundle: nil)
//                    let vc : UIViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController;
//                    vc.modalPresentationStyle = .fullScreen
//                    self.present(vc, animated: true, completion: nil)
//                }
//            }
        })
    }
}
