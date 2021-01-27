//
//  UIViewController+AlertWindows.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 31/12/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertWindow(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func showAlertSheet(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
