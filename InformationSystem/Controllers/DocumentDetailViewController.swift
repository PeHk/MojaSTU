//
//  DocumentDetailViewController.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 06/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import UIKit
import Firebase
import SnapKit
import SwiftEmptyState
 
class DocumentDetailViewController: UIViewController {
//    MARK: Outlets
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var downloadLabel: UILabel!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var downloadView: UIView! {
        didSet {
            downloadView.isHidden = true
            downloadView.layer.cornerRadius = 25
        }
    }
    @IBOutlet weak var labelName: UILabel! {
        didSet {
            labelName.text = subject.subjectName
            labelName.adjustsFontSizeToFitWidth = true
        }
    }
//    MARK: Empty table
    lazy var noDocumentsView = EmptyStateView(
        messageText: "Pre tento predmet nemáš žiadne dokumenty",
        titleText: "Žiadne dokumenty",
        image: UIImage(named: "emptyFiles")
    )
    lazy var noDocuments: EmptyStateManager = {
        
        let manager = EmptyStateManager(
            containerView: self.tableView,
            emptyView: self.noDocumentsView,
            animationConfiguration: .init(animationType: .fromBottom)
        )
        manager.hasContent = {
            !(Files.sharedInstance.arrayOfFolderFiles.isEmpty)
        }
        
        return manager
    }()
    
//    MARK: Variables
    var subject = EIndexSubject()
    var arrayDocuments : [Files]?
    var pdfURL: URL!
    var errorCounter = 0
    var showSkeleton = true
    
//    MARK: Instances
    let network: Network = Network()
    let htmlparser: HTMLParser = HTMLParser()
    let stringparser: StringParser = StringParser()
    
//    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
        checkDarkMode()
    
        DispatchQueue.global().async {
            self.getListedDocuments(url: self.subject.files)

            if !Files.sharedInstance.arrayOfFiles.isEmpty {
                self.arrayDocuments = Files.sharedInstance.arrayOfFiles
            }
            else if !Files.sharedInstance.arrayOfFolderFiles.isEmpty {
                self.arrayDocuments = Files.sharedInstance.arrayOfFolderFiles
            }
            else {
                DispatchQueue.main.async {
                    self.noDocuments.reloadState()
                    self.setEmptyView()
                    self.tableView.reloadSections([0], with: .automatic)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadSections([0], with: .automatic)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
//    MARK: Set empty view
    func setEmptyView(){
        showSkeleton = false
        tableView.rowHeight = 0.0
    }

//    MARK: Error occurred
    func errorOccurred(errorCounter: Int, url: String) {
        if errorCounter <= 3 {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Nastala chyba, skontrolujte si internetové pripojenie alebo prihlasovacie údaje!", message: "Počet pokusov na pripojenie: \(3 - errorCounter). Tlačidlom zrušiť zavriete aplikáciu!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Zrušiť", style: .destructive, handler: { action in
                    exit(0)
                }))
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                    self.requestForNewToken()
                    self.getListedDocuments(url: url)
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

//     MARK: Get documents
    func getListedDocuments(url: String) {
        network.getRequest(urlAsString: url, completionHandler: { success, statusCode, result in
            if !success {
                Analytics.logEvent("error_documentDetail", parameters: ["statusCode": statusCode])
                self.errorCounter += 1
                self.errorOccurred(errorCounter: self.errorCounter, url: url)
            }
            else {
                if result != nil {
                    self.htmlparser.getFiles(fromHtml: result!)
                }
            }
        })
    }
}
