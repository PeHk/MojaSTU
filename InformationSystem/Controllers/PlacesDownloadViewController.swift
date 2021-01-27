//
//  PlacesDownloadViewController.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 09/06/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import UIKit
import Firebase

class PlacesDownloadViewController: UIViewController {
    
    @IBOutlet weak var uploadStackView: UIStackView! {
        didSet {
            uploadStackView.isHidden = true
        }
    }
    @IBOutlet weak var staticSuccessLabel: UILabel!
    @IBOutlet weak var staticPoints: UILabel!
    @IBOutlet weak var staticEndDate: UILabel!
    @IBOutlet weak var staticUploadDate: UILabel!
    @IBOutlet weak var staticSubject: UILabel!
    @IBOutlet weak var staticName: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var uploadDateLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var checkMark: UIView! {
        didSet {
            checkMark.layer.cornerRadius = (checkMark.frame.height) / 2
            checkMark.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var controllerLabel: UILabel!
    @IBOutlet weak var tableLabel: UILabel! {
        didSet {
            tableLabel.isHidden = true
        }
    }
    @IBOutlet weak var downloadView: UIView! {
        didSet {
            downloadView.isHidden = true
            downloadView.layer.cornerRadius = 25
        }
    }
    @IBOutlet weak var downloadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameStackView: UIStackView! {
        didSet {
            nameStackView.isHidden = true
        }
    }
    @IBOutlet weak var subjectStackView: UIStackView! {
        didSet {
            subjectStackView.isHidden = true
        }
    }
    @IBOutlet weak var endDateStackView: UIStackView! {
        didSet {
            endDateStackView.isHidden = true
        }
    }
    @IBOutlet weak var uploadDateStackView: UIStackView! {
        didSet {
            uploadDateStackView.isHidden = true
        }
    }
    @IBOutlet weak var pointsStackView: UIStackView! {
        didSet {
            pointsStackView.isHidden = true
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var tableFooterView: UIView!

    
//    MARK: Constructors
    let network: Network = Network()
    let htmlparser: HTMLParser = HTMLParser()
    let stringparser: StringParser = StringParser()
    
    var teacher : String? = nil
    var name : String? = nil
    var points : String? = nil
    var subject : String? = nil
    var endDate : String? = nil
    var detail : String? = nil
    var uploadDate : String? = nil
    var filesArray : [UploadedFiles]?
    var errorCounter = 0
    var indicator = UIActivityIndicatorView()
    var fileURL: URL!
    var success : Bool? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
        checkDarkMode()
        indicator.startAnimating()
        
        if detail != "" {
            DispatchQueue.global().async {
                self.getDetail(url: "https://is.stuba.sk/auth/student/" + self.detail!)
                
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.setView()
                    self.tableView.reloadSections([0], with: .automatic)
                }
            }
            
        }
        Analytics.logEvent("placesDetailOpened", parameters: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    
//    MARK: Get detail of place
    func getDetail(url: String) {
        network.getRequest(urlAsString: url, completionHandler: { success, statusCode, result in
            if success {
                if result != nil {
                    self.uploadDate = self.htmlparser.getUploadDate(fromHtml: result!)
                    self.filesArray = self.htmlparser.getUploadedFiles(fromHtml: result!)
                    self.success = self.htmlparser.getSuccessUpload(fromHtml: result!)
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
    
    func setView() {
        if name != "" {
            nameLabel.text = name
            nameStackView.isHidden = false
        }

        if subject != "" {
            subjectLabel.text = subject
            subjectStackView.isHidden = false
        }
    
        if points != "" {
            pointsLabel.text = points
            pointsStackView.isHidden = false
        }
        
        if endDate != "" {
            endDateLabel.text = endDate
            endDateStackView.isHidden = false
        }
    
        if uploadDate != nil {
            uploadDateLabel.text = uploadDate
            uploadDateStackView.isHidden = false
        }
        
        if success != nil {
            if success! {
                uploadStackView.isHidden = false
            }
        }
        
        tableLabel.isHidden = false

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
                    self.getDetail(url: url)
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
}
