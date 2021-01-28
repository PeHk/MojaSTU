//
//  NotificationViewController.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 28/12/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import UIKit
import SwiftEmptyState
import SnapKit
import Firebase

class PersonViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate {

//    MARK: Outlets
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.searchTextField.delegate = self
            searchBar.backgroundImage = UIImage()
            searchBar.searchTextField.clearButtonMode = .never
            searchBar.delegate = self
        }
    }
//    MARK: Initial view
    lazy var startSearchView = EmptyStateView(
        messageText: "Pre vyhľadanie človeka začni písať jeho meno",
        titleText: "Vyhľadávanie ľudí na STU",
        image: UIImage(named: "contact")
    )
    lazy var startSearch: EmptyStateManager = {
    
        let manager = EmptyStateManager(
            containerView: self.tableView,
            emptyView: self.startSearchView,
            animationConfiguration: .init(animationType: .fromBottom)
        )
        manager.hasContent = {
            !(self.initial)
        }
        
        return manager
    }()
//    MARK: Not found view
    lazy var emptyStateView = EmptyStateView(
        messageText: "Vyhľadávaný používateľ neexistuje",
        titleText: "Nikoho sme nenašli!",
        image: UIImage(named: "undefined")
    )
    lazy var emptyStateManager: EmptyStateManager = {
        
        let manager = EmptyStateManager(
            containerView: self.tableView,
            emptyView: emptyStateView,
            animationConfiguration: .init(animationType: .fromBottom)
        )
        manager.hasContent = {
            !(self.notFound)
        }
        
        return manager
    }()
//    MARK: Variables
    var indicator = UIActivityIndicatorView()
    var peopleArray : [Person]?
    var timer: Timer?
    var initial = true
    var notFound = true
    var language = "sk"
//    MARK: Constants
    let suggestURL = "https://is.stuba.sk/auth/system/uissuggest.pl"
    let htmlParser = HTMLParser()
    let network = Network()
    let jsonParser = JSONParser()
    let review: Review = Review()

//    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        startSearch.reloadState()
        initObservers()
        checkObservers()
        setNameOfUser()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Analytics.logEvent("tabPersonFinderLoaded", parameters: nil)
        review.incrementOpen()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .languageSlovak, object: nil)
        NotificationCenter.default.removeObserver(self, name: .languageEnglish, object: nil)
    }
}
