//
//  SettingsController.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 28/12/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class SettingsViewController: UITableViewController {
     
//    MARK: Outlets
    @IBOutlet weak var emailControlCell: UITableViewCell!
    @IBOutlet weak var secondCellLabel: UILabel!
    @IBOutlet weak var emailControlLabel: UILabel!
    @IBOutlet weak var emailControlSecondLabel: UILabel!
    @IBOutlet weak var secondCellText: UILabel!
    @IBOutlet weak var thirdCellText: UILabel!
    @IBOutlet weak var thirdCell: UITableViewCell!
    @IBOutlet weak var firstCellLabel: UILabel!
    @IBOutlet weak var secondCell: UITableViewCell!
    @IBOutlet weak var firstCell: UITableViewCell!
    @IBOutlet weak var zeroCell: UITableViewCell!
    @IBOutlet weak var zeroMainLabel: UILabel!
    @IBOutlet weak var emailControlSwitch: UISwitch! {
        didSet {
            emailControlSwitch.addTarget(self, action: #selector(changeEmailControl), for: .valueChanged)
        }
    }
    @IBOutlet weak var automaticModeSwitch: UISwitch! {
        didSet {
            automaticModeSwitch.addTarget(self, action: #selector(automaticModeSwitched), for: .valueChanged)
        }
    }
    @IBOutlet weak var darkModeSwitch: UISwitch! {
        didSet {
            darkModeSwitch.addTarget(self, action: #selector(darkModeSwitched), for: .valueChanged)
        }
    }
    @IBOutlet weak var zeroSecondLabel: UILabel!
    
//    MARK: Instances
    let network: Network = Network()
    let htmlparser: HTMLParser = HTMLParser()
    let stringparser: StringParser = StringParser()
//    MARK: Variables
    var indicator = UIActivityIndicatorView()
    let locationManager = CLLocationManager()
    

//    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        tableView.tableFooterView = UIView()
        
        initObservers()
        let isDarkMode = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        if isDarkMode {
            NotificationCenter.default.post(name: .darkModeEnabled, object: nil)
            darkModeSwitch.isOn = true
        }
        else {
            NotificationCenter.default.post(name: .darkModeDisabled, object: nil)
            darkModeSwitch.isOn = false
        }
        
        let isAutomaticMode = UserDefaults.standard.bool(forKey: "automaticModeEnabled")
        if isAutomaticMode {
            automaticModeSwitch.isOn = true
            darkModeSwitch.isEnabled = false
            firstCell.isUserInteractionEnabled = false
        }
        else {
            automaticModeSwitch.isOn = false
            darkModeSwitch.isEnabled = true
            firstCell.isUserInteractionEnabled = true
        }
        
        if (UserDefaults.standard.object(forKey: "emailControlDisabled") == nil) {
            emailControlSwitch.isOn = true
        } else {
            let isControlEnabled = UserDefaults.standard.bool(forKey: "emailControlDisabled")
            if !isControlEnabled {
                emailControlSwitch.isOn = true
            } else {
                emailControlSwitch.isOn = false
            }
        }
    }
    
    deinit {
           NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
           NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
//    MARK: Dark mode switcher
    @IBAction func darkModeSwitched(_ sender: Any) {
        if darkModeSwitch.isOn == true {
            UserDefaults.standard.set(true, forKey: "darkModeEnabled")
            NotificationCenter.default.post(name: .darkModeEnabled, object: nil)
            Analytics.logEvent("darkModeEnabled", parameters: nil)
        }
        else {
            UserDefaults.standard.set(false, forKey: "darkModeEnabled")
            NotificationCenter.default.post(name: .darkModeDisabled, object: nil)
            Analytics.logEvent("darkModeDisabled", parameters: nil)
        }
    }
    
    @IBAction func changeEmailControl(_ sender: Any) {
        if emailControlSwitch.isOn == true {
            let alert = UIAlertController(title: "Upozornenie", message: "Pokračovaním súhlasíte, že aplikácia bude používať internetové pripojenie na pozadí.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Pokračovať", style: .default, handler: { action in
                UserDefaults.standard.set(false, forKey: "emailControlDisabled")
                Analytics.logEvent("emailControlEnabled", parameters: nil)
            }))
            alert.addAction(UIAlertAction(title: "Zrušiť", style: .destructive, handler: {action in
                self.emailControlSwitch.setOn(false, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            UserDefaults.standard.set(true, forKey: "emailControlDisabled")
            Analytics.logEvent("emailControlDisabled", parameters: nil)
        }
    }
    
    //    MARK: Automatic mode switcher
    @IBAction func automaticModeSwitched(_ sender: Any) {
        if automaticModeSwitch.isOn == true {
            retriveCurrentLocation()
            darkModeSwitch.isEnabled = false
            firstCell.isUserInteractionEnabled = false
            UserDefaults.standard.set(true, forKey: "automaticModeEnabled")
            Analytics.logEvent("automaticModeEnabled", parameters: nil)
        }
        else {
            darkModeSwitch.isEnabled = true
            firstCell.isUserInteractionEnabled = true
            UserDefaults.standard.set(false, forKey: "automaticModeEnabled")
            Analytics.logEvent("automaticModeDisabled", parameters: nil)
        }
    }
}
