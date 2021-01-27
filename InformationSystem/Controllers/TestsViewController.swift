//
//  TestsViewController.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 02/06/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import UIKit
import Firebase
import SnapKit
import SwiftEmptyState
import EventKit

class TestsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.isUserInteractionEnabled = false
            tableView.refreshControl = refreshControl
        }
    }
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    
    
    var arrayTests : [Tests]?
    var mainURL = "https://is.stuba.sk/auth/elis/ot/psani_testu.pl?vysledky=1"
    var errorCounter = 0
    var refreshPossible = false
    weak var timer: Timer?
    
//    MARK: Constructors
    let network: Network = Network()
    let htmlparser: HTMLParser = HTMLParser()
    let stringparser: StringParser = StringParser()
    
    //    MARK: Not found view
    lazy var emptyStateView = EmptyStateView(
        messageText: "Nemáte žiadne testy",
        titleText: "Žiadne testy nie sú k dispozicií!",
        image: UIImage(named: "test-black")
    )
    lazy var emptyStateManager: EmptyStateManager = {
        
        let manager = EmptyStateManager(
            containerView: self.tableView,
            emptyView: emptyStateView,
            animationConfiguration: .init(animationType: .fromBottom)
        )
        manager.hasContent = {
            !(self.arrayTests?.count == 0)
        }
        
        return manager
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        let isDarkMode = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
        checkDarkMode()
        startTimer()
        
        DispatchQueue.global().async {
            self.getTests(url: self.mainURL)
            DispatchQueue.main.async {
                self.tableView.reloadSections([0], with: .automatic)
                self.emptyStateManager.reloadState()
            }
        }
        Analytics.logEvent("testsOpened", parameters: nil)
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
                    self.getTests(url: url)
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
    func getTests(url: String) {
        refreshPossible = false
        network.getRequest(urlAsString: url, completionHandler: { success, statusCode, result in
            if success {
                if result != nil {
                    self.arrayTests = nil
                    self.arrayTests = self.htmlparser.getTests(fromHtml: result!)
                }
                else {
                    Analytics.logEvent("error_tests", parameters: ["statusCode": statusCode])
                    self.errorCounter += 1
                    self.errorOccurred(errorCounter: self.errorCounter, url: url)
                }
            }
            else {
                Analytics.logEvent("error_tests", parameters: ["statusCode": statusCode])
                self.errorCounter += 1
                self.errorOccurred(errorCounter: self.errorCounter, url: url)
            }
        })
    }
}
