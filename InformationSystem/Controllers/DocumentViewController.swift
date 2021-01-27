//
//  DocumentViewController.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 28/12/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import UIKit
import SkeletonView
import Firebase

class DocumentViewController: UIViewController {
    
//    MARK: Outlets
    @IBOutlet weak var documentLabel: UILabel!
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var tableHeaderView: UIView! 
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.isUserInteractionEnabled = false
        }
    }
    
//    MARK: Constants
    let mainURL = "https://is.stuba.sk/auth/student/list.pl?;lang=sk"
    let mainMarksURL = "https://is.stuba.sk/auth/student/pruchod_studiem.pl?;lang=sk"
    let xPathSubject = "/html/body/div[2]/div/div/form/table[2]/tbody/"
    
//    MARK: Variables
    var arraySubjects : [EIndexSubject]?
    var arraySemester = [Semester]()
    var errorCounter = 0

//    MARK: Instances
    let network: Network = Network()
    let htmlparser: HTMLParser = HTMLParser()
    let stringparser: StringParser = StringParser()
    let review: Review = Review()
    
//    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
        checkDarkMode()
        setNameOfUser()
        
        if !Documents.sharedInstance.arrayOfDocuments.isEmpty {
            arraySubjects = Documents.sharedInstance.arrayOfDocuments
            self.tableView.isUserInteractionEnabled = true
        }
        else {
            DispatchQueue.global().async() {
                self.getAllSubjects(url: self.mainURL, urlForMarks: self.mainMarksURL)
                self.arraySemester = Semester.sharedInstance.arrayOfSemesters
                self.arraySubjects = EIndexSubject.sharedInstance.arrayOfSubjects
                Documents.sharedInstance.arrayOfDocuments = EIndexSubject.sharedInstance.arrayOfSubjects
                DispatchQueue.main.async {
                    self.tableView.reloadSections([0], with: UITableView.RowAnimation.automatic)
                    self.tableView.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Files.sharedInstance.arrayOfFolderFiles.removeAll()
        Files.sharedInstance.arrayOfFiles.removeAll()
        checkDarkMode()
        tableView.reloadData()
        review.incrementOpen()
        Analytics.logEvent("tabDocumentsLoaded", parameters: nil)
        
    }
    deinit {
       NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
       NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
//     MARK: Error occurred
    func errorOccurred(errorCounter: Int, url: String, urlForMarks: String) {
        if errorCounter <= 3 {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Nastala chyba, skontrolujte si internetové pripojenie alebo prihlasovacie údaje!", message: "Počet pokusov na pripojenie: \(3 - errorCounter). Tlačidlom zrušiť zavriete aplikáciu!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Zrušiť", style: .destructive, handler: { action in
                    exit(0)
                }))
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                    self.requestForNewToken()
                    self.getAllSubjects(url: url, urlForMarks: urlForMarks)
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
    
//    MARK: Get subjects
    func getAllSubjects(url: String, urlForMarks: String) {
        network.getRequest(urlAsString: url, completionHandler: { success, statusCode, result in
            if !success {
                Analytics.logEvent("error_documents", parameters: ["statusCode": statusCode])
                self.errorCounter += 1
                self.errorOccurred(errorCounter: self.errorCounter, url: url, urlForMarks: urlForMarks)
            }
            else {
                if result != nil {
                    self.htmlparser.getSubjectName(fromHtml: result!)
                    self.htmlparser.getSemesters(html: result!)
                }
            }
        })
        
        network.getRequest(urlAsString: urlForMarks, completionHandler: { success, statusCode, result in
            if !success {
                Analytics.logEvent("error_documents", parameters: ["statusCode": statusCode])
                self.errorCounter += 1
                self.errorOccurred(errorCounter: self.errorCounter, url: url, urlForMarks: urlForMarks)
            }
            else {
                if result != nil {
                    self.htmlparser.getMarks(html: result!)
                }
                else {
                    Analytics.logEvent("error_documents", parameters: ["statusCode": statusCode])
                    self.errorCounter += 1
                    self.errorOccurred(errorCounter: self.errorCounter, url: url, urlForMarks: urlForMarks)
                }
            }
        })
    }
}
