//
//  ViewController+UserImage.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 28/12/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setNameOfUser() {
        let imageOfUserURL = "https://is.stuba.sk/auth/lide/foto.pl?id="
        let network: Network = Network()
        let tokenToHeader = UserDefaults.standard.value(forKey: "tokenToHeader") as! String
        let tokenToValue = UserDefaults.standard.value(forKey: "tokenToValue") as! String
        let userID = UserDefaults.standard.value(forKey: "userID") as! String
        let userName = UserDefaults.standard.value(forKey: "nameOfUser") as! String
        
        var imageOfUserData = Data()
    
        if (UserDefaults.standard.value(forKey: "userImage")) == nil {
        
            imageOfUserData = network.sendGETData(tokenToHeader: tokenToHeader, tokenToValue: tokenToValue, urlAsString:
            imageOfUserURL + userID)
            UserDefaults.standard.set(imageOfUserData, forKey: "userImage")
            
        }
        else {
            imageOfUserData = UserDefaults.standard.value(forKey: "userImage") as! Data
        }
        
        let circleSize = 40
        var imageOfUser = UIImage(data: imageOfUserData)
        imageOfUser = imageOfUser?.resize(maxWidthHeight: 30)
        let imageView = UIImageView(image: imageOfUser)
        imageView.frame = CGRect(x: 0, y: 0, width: circleSize, height: circleSize)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = (imageView.frame.size.height) / 2
        
               
        let nameButton = UIBarButtonItem(title: userName,
                                        style: .plain,
                                        target: self,
                                        action: #selector(ShowUserDetails))
        
        let userButton = UIBarButtonItem(customView: imageView)
        userButton.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ShowUserDetails)))
        
        navigationItem.rightBarButtonItems = [userButton, nameButton]
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc func ShowUserDetails () {
        checkDarkMode()
        let storyboard = UIStoryboard(name: "TimeTable", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "SideMenuController")
        self.present(vc, animated: true, completion: nil)
    }
}
