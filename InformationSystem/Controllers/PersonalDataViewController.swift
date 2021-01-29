//
//  PersonalDataViewController.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 01/01/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import UIKit
import SkeletonView
import Firebase

class PersonalDataViewController: UIViewController {
//    MARK: Outlets
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableFooterView: UIView!
    
//    MARK: Instances
    let network: Network = Network()
    let stringparser: StringParser = StringParser()
    let htmlparser: HTMLParser = HTMLParser()
    
//    MARK: Variables
    var errorCounter = 0
    var personalURL = "https://is.stuba.sk/auth/kontrola/?_m=22841;lang=sk"
    var arrayOfData : [KeyValue]?
    var indicator = UIActivityIndicatorView()
    var errorTitle = "Nastala chyba, skontrolujte si internetové pripojenie alebo prihlasovacie údaje!"
    var errorMessageFirst = "Počet pokusov na pripojenie: "
    var errorMessageLast = "Tlačidlom zrušiť zavriete aplikáciu!"
    var cancelString = "Zrušiť"
    
//    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
        checkObservers()
        indicator.startAnimating()
        
        DispatchQueue.global().async {
            self.getPersonalData()
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .languageSlovak, object: nil)
        NotificationCenter.default.removeObserver(self, name: .languageEnglish, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Analytics.logEvent("personalDataLoaded", parameters: nil)
        tableView.reloadData()
    }
    
//    MARK: Error Occurred
    func errorOccurred(errorCounter: Int) {
        if errorCounter <= 3 {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: self.errorTitle, message: self.errorMessageFirst + "\(3 - errorCounter). " + self.errorMessageLast, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: self.cancelString, style: .destructive, handler: { action in
                    exit(0)
                }))
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                    self.requestForNewToken()
                    self.getPersonalData()
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
    
//    MARK: Get data
    func getPersonalData() {
        network.getRequest(urlAsString: personalURL, completionHandler: { success, statusCode, result in
            if !success {
                Analytics.logEvent("error_personalData", parameters: ["statusCode": statusCode])
                self.errorCounter += 1
                self.errorOccurred(errorCounter: self.errorCounter)
            }
            else {
                if result != nil {
                    DispatchQueue.main.async {
                        let array = self.htmlparser.getPersonalData(fromHtml: result!)
                        if array != nil {
                            self.arrayOfData = array!
                        }
                    }
                }
                else {
                    Analytics.logEvent("error_personalData", parameters: ["statusCode": statusCode])
                    self.errorCounter += 1
                    self.errorOccurred(errorCounter: self.errorCounter)
                }
            }
        })
    }
}
