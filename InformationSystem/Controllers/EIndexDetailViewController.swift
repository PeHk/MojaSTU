//
//  EIndexDetailViewController.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 03/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import UIKit
import Firebase
import SwiftEmptyState
import SnapKit

class EIndexDetailViewController: UIViewController {

//      MARK: Outlets
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var excerciseLabel: UILabel! {
        didSet {
            excerciseLabel.isHidden = true
        }
    }
    @IBOutlet weak var seminarLabel: UILabel! {
        didSet {
            seminarLabel.isHidden = true
        }
    }
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var excercise: SeminarsControl!
    @IBOutlet weak var seminarStack: SeminarsControl!
    @IBOutlet weak var seminarCompleteStack: UIStackView!
    @IBOutlet weak var excerciseCompleteStack: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var markView: UIView! {
        didSet {
            markView.layer.cornerRadius = (markView.frame.height) / 2
            markView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var markLabel: UILabel! {
        didSet {
            markLabel.text = subject.subjectMark
            markLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var subjectName: UILabel! {
        didSet {
            subjectName.text = subject.subjectName
            subjectName.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var mainTableName: UILabel! {
        didSet {
            mainTableName.isHidden = true
        }
    }
    lazy var noPointsView = EmptyStateView(
        messageText: "V predmete nemáš žiadne bodové hárky",
        titleText: "Žiadne body",
        image: UIImage(named: "emptySheet")
    )
    lazy var noPoints: EmptyStateManager = {
        
        let manager = EmptyStateManager(
            containerView: self.tableView,
            emptyView: self.noPointsView,
            animationConfiguration: .init(animationType: .fromBottom)
        )
        manager.hasContent = {
            !(self.arrayOfTables.count == 0)
        }
        
        return manager
    }()
    
//    MARK: Instances
    let network: Network = Network()
    let htmlparser: HTMLParser = HTMLParser()
    let stringparser: StringParser = StringParser()
    
    var arrayOfTables = [SheetsTable]()
    var subject = EIndexSubject()
    var errorCounter = 0
    var indicator = UIActivityIndicatorView()
    var seminarsText = "Cvičenia: "
    var errorTitle = "Nastala chyba, skontrolujte si internetové pripojenie alebo prihlasovacie údaje!"
    var errorMessageFirst = "Počet pokusov na pripojenie: "
    var errorMessageLast = "Tlačidlom zrušiť zavriete aplikáciu!"
    var cancelString = "Zrušiť"

//  MARK:   Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
        checkObservers()
        indicator.startAnimating()

        if !subject.sheets.isEmpty {
            DispatchQueue.global().async {
                self.getSheets(url: "https://is.stuba.sk" + self.subject.sheets)
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.checkSeminarPresence()
                    self.checkExcercisePresence()
                }
            }
        }
        else {
            noPoints.reloadState()
            indicator.stopAnimating()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .languageSlovak, object: nil)
        NotificationCenter.default.removeObserver(self, name: .languageEnglish, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Analytics.logEvent("subjectDetailLoaded", parameters: nil)
    }
   
//     MARK: Check excercise
    func checkExcercisePresence() {
        excerciseLabel.isHidden = false
        var excersiseIsEmpty = true
        var excercisePresence = subject.presence.count
        
        for item in subject.presence {
            if item != UIColor.lightGray {
                excersiseIsEmpty = false
            }
        }
        
        if excersiseIsEmpty {
            excerciseCompleteStack.isHidden = true
            tableHeaderView.frame.size.height = tableHeaderView.frame.size.height - 30
            seminarLabel.text = seminarsText
            tableView.reloadData()
        }
        else {
            if excercisePresence > 13 {
                excercisePresence = 13
            }
            for i in 0..<excercisePresence {
                excercise.addCircle(color: subject.presence[i], text: String(i + 1))
            }
        }
    }
    
//     MARK: Check seminar
    func checkSeminarPresence() {
        seminarLabel.isHidden = false
        var seminarPresence = subject.seminarPresence.count
        var isEmpty = true
        
        for item in subject.seminarPresence {
            if item != UIColor.lightGray {
                isEmpty = false
            }
        }
        
        if isEmpty {
            seminarCompleteStack.isHidden = true
            tableHeaderView.frame.size.height = tableHeaderView.frame.size.height - 30
            tableView.reloadData()
        }
        else if seminarPresence > 13 {
            seminarPresence = 13
            
            for i in 0..<seminarPresence {
                seminarStack.addCircle(color: subject.seminarPresence[i], text: String(i + 1))
            }
        }
    }
    
//  MARK: Error occurred
    func errorOccurred(url: String, errorCounter: Int) {
       if errorCounter <= 3 {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: self.errorTitle, message: self.errorMessageFirst + "\(3 - errorCounter). " + self.errorMessageLast, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: self.cancelString, style: .destructive, handler: { action in
                    exit(0)
                }))
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                    self.requestForNewToken()
                    self.getSheets(url: url)
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
    
// MARK: Get sheets
    func getSheets(url: String) {
        network.getRequest(urlAsString: url, completionHandler: { success, statusCode, result in
            if success {
                if result != nil {
                    let array = self.htmlparser.getSheets(fromHtml: result!)
                    if array != nil {
                        self.arrayOfTables = array!
                        if self.arrayOfTables.count == 0 {
                            DispatchQueue.main.async {
                                self.noPoints.reloadState()
                                self.tableHeaderView.frame.size.height = self.tableHeaderView.frame.size.height - 39.5
                                self.indicator.stopAnimating()
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.showView()
                            }
                        }
                    }
                }
                else {
                    Analytics.logEvent("error_subjectDetail", parameters: ["statusCode": statusCode])
                    self.errorCounter += 1
                    self.errorOccurred(url: url, errorCounter: self.errorCounter)
                }
            }
            else {
                Analytics.logEvent("error_subjectDetail", parameters: ["statusCode": statusCode])
                self.errorCounter += 1
                self.errorOccurred(url: url, errorCounter: self.errorCounter)
            }
        })
    }
    
    func showView() {
        self.mainTableName.alpha = 0
        self.mainTableName.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.mainTableName.alpha = 1
        }
    }
}



