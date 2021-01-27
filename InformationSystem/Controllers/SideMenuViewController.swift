//
//  SideMenuController.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 26/12/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import UIKit
import Firebase

class SideMenuViewController: UIViewController {
    
//    MARK: Outlets
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.image = UIImage(data: UserDefaults.standard.value(forKey: "userImage") as! Data)
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = (imageView.frame.size.height) / 2
        }
    }
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.text = UserDefaults.standard.value(forKey: "nameOfUser") as? String
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ID: " + userID, style: .plain, target: self, action: nil)
        }
    }
    @IBOutlet weak var passwordLabel: UILabel! 
    @IBOutlet weak var informativeLabel: UILabel!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emailLabel: UILabel!
    
//    MARK: Constants
    let arrayOfSettings = ["Osobné údaje", "Nastavenia", "Odhlásiť sa"]
    let wifiCredentialsURL = "https://is.stuba.sk/auth/wifi/heslo_vpn_sit.pl"
    let userIDURL = "https://is.stuba.sk/auth/student/studium.pl?studium=142008;obdobi=560;lang=sk"
    let wifiNameXPath = "/html/body/div[2]/div/div/form/table/tbody/tr[1]/td[2]/div/b"
    let wifiPasswordXPath = "/html/body/div[2]/div/div/form/table/tbody/tr[2]/td[2]/div/b"
    let wifiNameXPath2 = "/html/body/div[2]/div/div/form/table/tbody/tr[1]/td[2]/span/b"
    let wifiPasswordXPath2 = "/html/body/div[2]/div/div/form/table/tbody/tr[2]/td[2]/span/b"
    
//    MARK: Variables
    var wifiName = String()
    var wifiPassword = String()
    var userID = UserDefaults.standard.value(forKey: "userID") as! String
    var errorCounter = 0

//    MARK: Instances
    let network: Network = Network()
    let htmlparser: HTMLParser = HTMLParser()
    let stringparser: StringParser = StringParser()
    
//   MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
        checkDarkMode()
        
        NotificationCenter.default.addObserver(self, selector: #selector(passwordChanged(_:)), name: .passwordChanged, object: nil)
        
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector((longPressFunction(_:))))
        self.passwordLabel.addGestureRecognizer(longPress)
        
        DispatchQueue.main.async {
            self.getWifiCredentials()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        Analytics.logEvent("tabSideMenuLoaded", parameters: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .passwordChanged, object: nil)
    }
    
    @objc func passwordChanged(_:Notification) {
        getWifiCredentials()
    }
    
    
//    MARK: Error Occurred
    func errorOccurred(errorCounter: Int) {
        if errorCounter <= 3 {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Nastala chyba, skontrolujte si internetové pripojenie alebo prihlasovacie údaje!", message: "Počet pokusov na pripojenie: \(3 - errorCounter). Tlačidlom zrušiť zavriete aplikáciu!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Zrušiť", style: .destructive, handler: { action in
                    exit(0)
                }))
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                    self.requestForNewToken()
                    self.getWifiCredentials()
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        else {
            DispatchQueue.main.async {
                self.resetDefaults()
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc : UIViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController;
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }

//    MARK: Wifi Credentials
    func getWifiCredentials() {
        if (UserDefaults.standard.value(forKey: "WifiName") == nil || UserDefaults.standard.value(forKey: "WifiPassword") == nil) {
            network.getRequest(urlAsString: wifiCredentialsURL, completionHandler: { success, statusCode, result in
                if success {
                    if result != nil {
                        self.wifiName = self.htmlparser.getNewWifiName(html: result!)!
                        self.wifiPassword = self.htmlparser.getNewPassword(html: result!)!
                        
                        UserDefaults.standard.set(self.wifiName, forKey: "WifiName")
                        UserDefaults.standard.set(self.wifiPassword, forKey: "WifiPassword")
                        
                        DispatchQueue.main.async {
                            self.emailLabel.hideSkeleton()
                            self.emailLabel.text = self.wifiName
                            self.passwordLabel.hideSkeleton()
                            self.passwordLabel.text = self.wifiPassword
                        }
                    }
                    else {
                        Analytics.logEvent("error_WifiCredentials", parameters: ["statusCode": statusCode])
                        self.errorCounter += 1
                        self.errorOccurred(errorCounter: self.errorCounter)
                    }
                }
                else {
                    Analytics.logEvent("error_WifiCredentials", parameters: ["statusCode": statusCode])
                    self.errorCounter += 1
                    self.errorOccurred(errorCounter: self.errorCounter)
                }
            })
        }
        else {
            emailLabel.hideSkeleton()
            emailLabel.text = UserDefaults.standard.value(forKey: "WifiName") as? String
            passwordLabel.hideSkeleton()
            passwordLabel.text = UserDefaults.standard.value(forKey: "WifiPassword") as? String
        }
    }
    

}
