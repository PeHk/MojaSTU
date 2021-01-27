//
//  LoginViewController.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 03/11/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class LoginViewController: UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }

//    MARK: Outlets
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.cornerRadius = 30
        }
    }
    @IBOutlet weak var passwordField: UITextField! {
        didSet {
            passwordField.setPadding()
        }
    }
    @IBOutlet weak var loginField: UITextField! {
        didSet {
            loginField.setPadding()
        }
    }
    @IBOutlet weak var indicator: UIActivityIndicatorView! {
        didSet {
            indicator.isHidden = true
        }
    }
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var universityLogo: UIImageView!
    
//    MARK: Constants
    let nameOfUserData = "lang=sk&osobni=1&z=1&k=1&f=0&studijni_zpet=0&rozvrh=3187&format=html&zobraz=Zobrazi%C5%A5;lang=sk"
    let userIDURL = "https://is.stuba.sk/auth/student/studium.pl"
    let userIDXPath = "/html/body/div[2]/div/div/form/table[2]/tbody/tr[1]/td[2]/small"
    
//    MARK: Variables
    var HTML = String()
    var nameOfUser = String()
    var userID = String()
    var loginName = String()
    var loginPassword = String()
    var errorCounter = 0
    
//    MARK: Instances
    let network: Network = Network()
    let htmlparser: HTMLParser = HTMLParser()
    let stringparser: StringParser = StringParser()
    
    //    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
        checkDarkMode()
        Analytics.logEvent("app_started", parameters: nil)
        print(UserDefaults.standard.value(forKey: "userID") != nil)
        if (UserDefaults.standard.value(forKey: "userID") != nil && UserDefaults.standard.value(forKey: "nameOfUser") != nil)
        {
            if (KeychainWrapper.standard.hasValue(forKey: "name") && KeychainWrapper.standard.hasValue(forKey: "pass")) {
                loginField.text = KeychainWrapper.standard.string(forKey: "name")
                passwordField.text = KeychainWrapper.standard.string(forKey: "pass")
                showActivityIndicator()
                DispatchQueue.main.async {
                    self.getUserInfo(completion: { status in
                        if status {
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "TimeTableController", sender: self)
                                Analytics.logEvent(AnalyticsEventLogin, parameters: nil)
                            }
                        }
                    })
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
//    MARK: Auth success
    func authentificationSuccess() {
        KeychainWrapper.standard.set(loginName, forKey: "name", withAccessibility: .alwaysThisDeviceOnly)
        KeychainWrapper.standard.set(loginPassword, forKey: "pass", withAccessibility: .alwaysThisDeviceOnly)
        DispatchQueue.main.async {
            self.getUserInfo(completion: { status in
                if status {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "TimeTableController", sender: self)
                        Analytics.logEvent(AnalyticsEventLogin, parameters: nil)
                    }
                }
            })
        }
    }
    
//    MARK: Auth denied
    func accessDenied() {
        DispatchQueue.main.async {
            self.showAlertWindow(title: "Nesprávne údaje!", message: "Prosím skontrolujte si zadané údaje a skúste znova.")
            self.passwordField.shake()
            self.loginField.shake()
            self.indicator.isHidden = true
        }
    }
    
//    MARK: Error Occurred
    func errorOccurred(errorCounter: Int) {
        if errorCounter <= 3 {
            DispatchQueue.main.async {
                self.indicator.isHidden = true
                let alert = UIAlertController(title: "Nastala chyba!", message: "Počet pokusov na pripojenie: \(4 - errorCounter)", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                    self.autenticate()
                    self.indicator.isHidden = false
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else {
            DispatchQueue.main.async {
                self.resetDefaults()
            }
        }
    }
    
//    MARK: Button tapped
    @IBAction func loginTapped(_ sender: Any?) {
        if let password = passwordField.text, !password.isEmpty, let login = loginField.text, !login.isEmpty {
            loginName = login
            loginPassword = password
            errorCounter = 0
            showActivityIndicator()
    
            DispatchQueue.global().async {
                self.autenticate()
            }
        }
        else {
            if let passwordText = passwordField.text, passwordText.isEmpty {
                passwordField.shake()
                indicator.isHidden = true
            }
            if let loginText = loginField.text, loginText.isEmpty {
                loginField.shake()
                indicator.isHidden = true
            }
        }
    }
    
    func showAnimated(in stackView: UIStackView) {
        if indicator.isHidden {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.indicator.isHidden = false
                    stackView.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }
    
//    MARK: Activity indicator
    func showActivityIndicator() {
        showAnimated(in: mainStack)
        indicator.startAnimating()
        view.endEditing(true)
    }
    
//    MARK: Set the user info
    func getUserInfo(completion: @escaping (Bool) -> Void) {
        if UserDefaults.standard.value(forKey: "userID") == nil || UserDefaults.standard.value(forKey: "nameOfUser") == nil {
            network.getRequest(urlAsString: userIDURL, completionHandler: {success, statusCode, result in
                if !success {
                    if statusCode == 403 {
                        self.errorCounter += 1
                        self.errorOccurred(errorCounter: self.errorCounter)
                    }
                    else {
                        completion(false)
                    }
                }
                else {
                    if result != nil {
                        self.userID = self.htmlparser.getXPathvalue(xPath: self.userIDXPath, fromHtml: result!)
                        
                        let userIdentity = self.htmlparser.getUserID(fromHtml: result!)
                        if userIdentity != nil {
                            self.userID = userIdentity!
                        }
                        let userName = self.htmlparser.getUserName(fromHtml: result!)
                        if userName != nil {
                            self.nameOfUser = userName!
                        }

                        UserDefaults.standard.set(self.nameOfUser, forKey: "nameOfUser")
                        UserDefaults.standard.set(self.userID, forKey: "userID")
                        completion(true)
                    }
                    else {
                        completion(false)
                    }
                }
            })
        }
        else {
            userID = UserDefaults.standard.value(forKey: "userID") as! String
            nameOfUser = UserDefaults.standard.value(forKey: "nameOfUser") as! String
            completion(true)
        }
    }
    
//    MARK: Autenticate user
    func autenticate() {
        self.network.authenticationLogin(login: self.loginName, password: self.loginPassword, noRedirect: true, completionHandler: { statusCode, success in
            if !success {
                if statusCode != 403 && statusCode != 302 {
                    self.accessDenied()
                }
                else {
                    Analytics.logEvent("error_login", parameters: ["status_code": statusCode])
                    self.errorCounter += 1
                    self.errorOccurred(errorCounter: self.errorCounter)
                }
            }
            else {
                self.authentificationSuccess()
            }
        })
    }
}
