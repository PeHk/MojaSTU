//
//  PlacesViewController.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 07/04/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import UIKit
import Firebase
import SnapKit
import SwiftEmptyState
import EventKit

class PlacesViewController: UIViewController {
    //    MARK: Outlets
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var tableView: UITableView!
    //    MARK: Variables
    var mainURL = "https://is.stuba.sk/auth/student/odevzdavarny.pl?lang=sk"
    var placesArray : [PlacesTables]?
    var studyID : String? = nil
    var semesterID : String? = nil
    var errorCounter = 0
    
    //    MARK: Constructors
    let network: Network = Network()
    let htmlparser: HTMLParser = HTMLParser()
    let stringparser: StringParser = StringParser()
    
    //    MARK: Not found view
    lazy var emptyStateView = EmptyStateView(
        messageText: "Nemáte žiadne miesta odovzdania",
        titleText: "Žiadne miesta odovzdania!",
        image: UIImage(named: "places")
    )
    lazy var emptyStateManager: EmptyStateManager = {
        
        let manager = EmptyStateManager(
            containerView: self.tableView,
            emptyView: emptyStateView,
            animationConfiguration: .init(animationType: .fromBottom)
        )
        manager.hasContent = {
            !(self.placesArray?.count == 0 || self.placesArray?.first?.array.count == 1 && self.placesArray?.count == 1 || self.placesArray?[0].array.count == 1 && self.placesArray?[1].array.count == 1)
        }
        
        return manager
    }()
    
    //    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
        checkDarkMode()
        
        DispatchQueue.global().async {
            if self.studyID != nil && self.semesterID != nil {
                self.mainURL = "https://is.stuba.sk/auth/student/odevzdavarny.pl?studium=\(self.studyID!);obdobi=\(self.semesterID!);lang=sk"
            }
            self.getTables(url: self.mainURL)

            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.emptyStateManager.reloadState()
            }
        }
        Analytics.logEvent("placesOpened", parameters: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
//  MARK: Error occurred
    func errorOccurred(errorCounter: Int, url: String) {
        if errorCounter <= 3 {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Nastala chyba, skontrolujte si internetové pripojenie alebo prihlasovacie údaje!", message: "Počet pokusov na pripojenie: \(3 - errorCounter). Tlačidlom zrušiť zavriete aplikáciu!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Zrušiť", style: .destructive, handler: { action in
                    exit(0)
                }))
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                    self.requestForNewToken()
                    self.getTables(url: url)
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
    //    MARK: Get tables for places
    func getTables(url: String) {
        network.getRequest(urlAsString: url, completionHandler: { success, statusCode, result in
            if success {
                if result != nil {
                    self.placesArray = self.htmlparser.getPlacesTables(fromHtml: result!)
                }
                else {
                    Analytics.logEvent("error_places", parameters: ["statusCode": statusCode])
                    self.errorCounter += 1
                    self.errorOccurred(errorCounter: self.errorCounter, url: url)
                }
            }
            else {
                Analytics.logEvent("error_places", parameters: ["statusCode": statusCode])
                self.errorCounter += 1
                self.errorOccurred(errorCounter: self.errorCounter, url: url)
            }
        })
    }
}


