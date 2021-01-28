//
//  TimeTableController.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 07/11/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import UIKit
import Firebase
import SnapKit
import SwiftEmptyState
import FirebaseCrashlytics

class TimeTableController: UIViewController {
    
//    MARK: Outlets
    @IBOutlet weak var tableView: UITableView! 
    @IBOutlet weak var timeTableDay: UILabel! {
        didSet {
            indexOfDay = Date().dayNumberOfWeek()!
            timeTableDay.text = nameOfDays[indexOfDay]
        }
    }
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var nameDayLabel: UILabel!
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.isHidden = true
        }
    }
    
//    MARK: Constants
    let nameOfDays = ["nil", "Nedeľa", "Pondelok", "Utorok", "Streda", "Štvrtok", "Piatok", "Sobota"]
    let dateFormatter = DateFormatter()
    
//    MARK: Variables
    var timeTableCells : [String] = []
    var userID = UserDefaults.standard.value(forKey: "userID") as! String
    var indexOfDay = Int()
    var indexOfCurrentDay = 0
    var HTMLTimeTable = String()
    var daySubjects = [TimeTableSubject]()
    var timeTableURL = String()
    var errorCounter = 0
    var currentDay = Date().dayNumberOfWeek()! - 1
    var currentDate = Date()
    
    
//    MARK: Empty table
    lazy var noSubjectsView = EmptyStateView(
        messageText: "Na dnešný deň nemáš žiadne rozvrhové akcie",
        titleText: "Žiadny rozvrh",
        image: UIImage(named: "emptyTimeTable")
    )
    
    lazy var noSubjects: EmptyStateManager = {
        
        let manager = EmptyStateManager(
            containerView: self.tableView,
            emptyView: self.noSubjectsView,
            animationConfiguration: .init(animationType: .fromBottom)
        )
        manager.hasContent = {
            !(self.daySubjects.isEmpty)
        }
        
        return manager
    }()
        
    
//     MARK: Instances
    let network: Network = Network()
    let htmlparser: HTMLParser = HTMLParser()
    let jsonparser: JSONParser = JSONParser()
    let stringparser: StringParser = StringParser()
    let review: Review = Review()
    
//    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        timeTableURL = "https://is.stuba.sk/auth/katalog/rozvrhy_view.pl?rozvrh_student_obec=1?zobraz=1;format=json;rozvrh_student=\(userID);zpet=../student/moje_studium.pl?_m=3110,studium=141967,obdobi=560;lang=sk"
        addRecognizers()
        initObservers()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dateChanged(_:)), name: .dateChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshBadge(_:)), name: .checkEmailsCount, object: nil)
        
        checkDarkMode()
        setNameOfUser()
        initialBadge()
        getTimeTable()
        getNameDay()
        let currentDateString = dateFormatter.string(from: currentDate)
        dateLabel.text = currentDateString
        self.noSubjects.reloadState()
        
        if (UserDefaults.standard.object(forKey: "windowAfterUpdate") == nil) {
            let alert = UIAlertController(
                title: "Dôležité upozornenie",
                message: "Notifikácie je možné prijímať iba, ak je aplikácia v stave \"bežiaca na pozadí\" (viď obrázok) - nie je ukončená. Žiaľ, je to jediný možný spôsob, nakoľko sa nejedná o oficálnu aplikáciu pre AIS.\n Svoju voľbu môžete jednoducho zmeniť aj v nastaveniach aplikácie.",
                preferredStyle: .actionSheet)
            
        let image = UIImage(named: "terminatedApp")!
            alert.addImage(image: image)
            alert.addAction(UIAlertAction(title: "Zapnúť notifikácie", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Vypnúť notifikácie", style: .destructive, handler: {action in
                UserDefaults.standard.set(true, forKey: "emailControlDisabled")
            }))
        
            self.present(alert, animated: true, completion: nil)
        }
        UserDefaults.standard.set(true, forKey: "windowAfterUpdate")
    }
    
    @objc func dateChanged(_ notification: Notification) {
        currentDate = Date()
        let currentDateString = dateFormatter.string(from: currentDate)
        let userDefaultsValue = UserDefaults.standard.string(forKey: "currentDate")
        if (userDefaultsValue != nil && userDefaultsValue! != currentDateString) {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            indexOfDay = Date().dayNumberOfWeek()!
            timeTableDay.text = nameOfDays[indexOfDay]
            getNameDay()
            getTimeTable()
            self.noSubjects.reloadState()
            dateLabel.text = currentDateString
            UserDefaults.standard.set(currentDateString, forKey: "currentDate")
            currentDay = Date().dayNumberOfWeek()! - 1
            indexOfCurrentDay = 0
            Analytics.logEvent("dateChanged", parameters: nil)
        } else {
            UserDefaults.standard.set(currentDateString, forKey: "currentDate")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        Analytics.logEvent("tabTimeTableLoaded", parameters: nil)
        checkScroll()
        review.incrementOpen()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .dateChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .checkEmailsCount, object: nil)
    }
    
    @IBAction func refreshBadge(_ notification: Notification) {
        setBadgeDirectly()
    }
    
//    MARK: Error occurred
    func errorOccurred(errorCounter: Int) {
        print(errorCounter)
        if errorCounter >= 3 {
            DispatchQueue.main.async {
                self.resetDefaults()
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc : UIViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController;
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        else {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Nastala chyba, skontrolujte si internetové pripojenie alebo prihlasovacie údaje!", message: "Počet pokusov na pripojenie: \(3 - errorCounter). Tlačidlom zrušiť zavriete aplikáciu!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Zrušiť", style: .destructive, handler: { action in
                    exit(0)
                }))
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                    self.requestForNewToken()
                    self.getTimeTable()
                    self.getNameDay()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
//     MARK: Time table request
    func getTimeTable() {
        network.getJSON(urlAsString: timeTableURL, completionHandler: { success, statusCode, result in
            if success {
                if result != nil {
                    self.HTMLTimeTable = result!
                    self.jsonparser.HTMLstring = self.HTMLTimeTable
                    self.jsonparser.parseTimeTable(dayOfWeek: String(self.indexOfDay - 1))
                    self.daySubjects = self.jsonparser.sortedDaySubjects
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.checkScroll()
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                    }
                }
                else {
                    self.errorCounter += 1
                    self.errorOccurred(errorCounter: self.errorCounter)
                }
            }
            else {
                self.errorCounter += 1
                self.errorOccurred(errorCounter: self.errorCounter)
            }
        })
    }
    
    func getNameDay() {
        network.getRequest(urlAsString: "https://is.stuba.sk/auth/?lang=sk", completionHandler: { success, statusCode, result in
            if success {
                if result != nil {
                    let name = self.htmlparser.getNameDay(fromHtml: result!)
                    if name != nil {
                        DispatchQueue.main.async {
                            self.nameDayLabel.text = "Meniny má: " + name! 
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.nameDayLabel.isHidden = true
                        }
                    }
                }
                else {
                    self.errorCounter += 1
                    self.errorOccurred(errorCounter: self.errorCounter)
                }
            }
            else {
                self.errorCounter += 1
                self.errorOccurred(errorCounter: self.errorCounter)
            }
        })
    }
}
