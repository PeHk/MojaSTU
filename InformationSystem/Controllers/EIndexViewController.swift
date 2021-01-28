//
//  EIndexViewController.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 28/12/2019.
//  Copyright © 2019 Peter Hlavatík. All rights reserved.
//

import UIKit
import Firebase
import SkeletonView

class EIndexViewController: UIViewController {
//    MARK: Outlets
    @IBOutlet weak var placesLabel: UILabel! {
        didSet {
            placesLabel.layer.masksToBounds = true
            placesLabel.showAnimatedGradientSkeleton()
        }
    }
    @IBOutlet weak var testsLabel: UILabel! {
        didSet {
            testsLabel.layer.masksToBounds = true
            testsLabel.showAnimatedGradientSkeleton()
        }
    }
    @IBOutlet weak var placesView: UIView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(placesTapped))
            placesView.addGestureRecognizer(tap)
            placesView.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var placesIcon: UIView! {
        didSet {
            placesIcon.layer.cornerRadius = (placesIcon.frame.height) / 2
            placesIcon.layer.masksToBounds = true
            placesIcon.showAnimatedGradientSkeleton()
        }
    }
    @IBOutlet weak var testIcon: UIView! {
        didSet {
            testIcon.layer.cornerRadius = (testIcon.frame.height) / 2
            testIcon.layer.masksToBounds = true
            testIcon.showAnimatedGradientSkeleton()
        }
    }
    @IBOutlet weak var testsView: UIView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(testsTapped))
            testsView.addGestureRecognizer(tap)
            testsView.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.refreshControl = refreshControl
        }
    }
    @IBOutlet weak var stackViewSemester: UIStackView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(displayPickerView))
            stackViewSemester.addGestureRecognizer(tapGesture)
            stackViewSemester.isUserInteractionEnabled = true
            stackViewSemester.clipsToBounds = true
            stackViewSemester.showAnimatedGradientSkeleton()
        }
    }
    @IBOutlet weak var dropDownImage: UIImageView!
    @IBOutlet weak var eIndexLabel: UILabel!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var semesterLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var topBorderView: UIView!
    
    
//    MARK: Constants
    let xPathSubject = "/html/body/div[2]/div/div/form/table[2]/tbody/"
    
//    MARK: Variables
    var mainURL = "https://is.stuba.sk/auth/student/list.pl?;lang=sk"
    var mainMarksURL = "https://is.stuba.sk/auth/student/pruchod_studiem.pl?;lang=sk"
    var textField : UITextField!
    var semester = String()
    var subject = String()
    var arraySubjects : [EIndexSubject]?
    var picker = UIPickerView()
    var arraySemester = [Semester]()
    var actualSemester = String()
    var refreshPossible = false
    var errorCounter = 0
    var reloadFlag = false
    var actualIDOfSemester = String()
    var actualIDOfStudy = String()
    weak var timer: Timer?
    var errorTitle = "Nastala chyba, skontrolujte si internetové pripojenie alebo prihlasovacie údaje!"
    var errorMessageFirst = "Počet pokusov na pripojenie: "
    var errorMessageLast = "Tlačidlom zrušiť zavriete aplikáciu!"
    var cancelString = "Zrušiť"
    
    
//    MARK: Constructors
    let network: Network = Network()
    let htmlparser: HTMLParser = HTMLParser()
    let stringparser: StringParser = StringParser()
    let review: Review = Review()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        let isDarkMode = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        
        return refreshControl
    }()
    
//    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
        checkObservers()
        createPickerView()
        setNameOfUser()
        startTimer()
       
        if !EIndexSubject.sharedInstance.arrayOfSubjects.isEmpty && !Semester.sharedInstance.arrayOfSemesters.isEmpty {
            arraySubjects = EIndexSubject.sharedInstance.arrayOfSubjects
            arraySemester = Semester.sharedInstance.arrayOfSemesters
            actualSemester = Semester.sharedInstance.actualSemester
            setSemesterLabelWithoutRequest()
            self.tableView.isUserInteractionEnabled = true
        }
        else {
            DispatchQueue.global().async {
                self.getSubjectTable(url: self.mainURL, urlForMarks: self.mainMarksURL)
                self.arraySemester = Semester.sharedInstance.arrayOfSemesters
                self.arraySubjects = EIndexSubject.sharedInstance.arrayOfSubjects
                self.actualSemester = Semester.sharedInstance.actualSemester
                
                Documents.sharedInstance.arrayOfDocuments = EIndexSubject.sharedInstance.arrayOfSubjects
                DispatchQueue.main.async {
                    self.picker.reloadAllComponents()
                    self.tableView.reloadSections([0], with: UITableView.RowAnimation.automatic)
                    self.tableView.isUserInteractionEnabled = true
                    self.setSemesterLabel()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadSections([0], with: UITableView.RowAnimation.automatic)
        Analytics.logEvent("tabEIndexLoaded", parameters: nil)
        review.incrementOpen()
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
//  MARK: Error occurred
    func errorOccurred(errorCounter: Int, url: String, urlForMarks: String) {
       if errorCounter <= 3 {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: self.errorTitle, message: self.errorMessageFirst + "\(3 - errorCounter). " + self.errorMessageLast, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: self.cancelString, style: .destructive, handler: { action in
                    exit(0)
                }))
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                    self.requestForNewToken()
                    self.getSubjectTable(url: url, urlForMarks: urlForMarks)
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
    
//  MARK: Get on subjects
    func getSubjectTable(url: String, urlForMarks: String) {
        refreshPossible = false
        network.getRequest(urlAsString: url, completionHandler: { success, statusCode, result in
            if !success {
                Analytics.logEvent("error_eIndex", parameters: ["statusCode": statusCode])
                self.errorCounter += 1
                self.errorOccurred(errorCounter: self.errorCounter, url: url, urlForMarks: urlForMarks)
            }
            else {
                if result != nil {
                    self.htmlparser.getSubjectName(fromHtml: result!)
                    if Semester.sharedInstance.arrayOfSemesters.isEmpty {
                        self.htmlparser.getSemesters(html: result!)
                    }
                }
                else {
                    Analytics.logEvent("error_eIndex", parameters: ["statusCode": statusCode])
                    self.errorCounter += 1
                    self.errorOccurred(errorCounter: self.errorCounter, url: url, urlForMarks: urlForMarks)
                }
            }
        })
        
        network.getRequest(urlAsString: urlForMarks, completionHandler: { success, statusCode, result in
            if !success {
                Analytics.logEvent("error_eIndex", parameters: ["statusCode": statusCode])
                self.errorCounter += 1
                self.errorOccurred(errorCounter: self.errorCounter, url: url, urlForMarks: urlForMarks)
            }
            else {
                if result != nil {
                    self.htmlparser.getMarks(html: result!)
                }
                else {
                    Analytics.logEvent("error_eIndex", parameters: ["statusCode": statusCode])
                    self.errorCounter += 1
                    self.errorOccurred(errorCounter: self.errorCounter, url: url, urlForMarks: urlForMarks)
                }
            }
        })
    }
    @objc func placesTapped() {
        if let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: "placesViewController") as? PlacesViewController {
            destinationViewController.studyID = actualIDOfStudy
            destinationViewController.semesterID = actualIDOfSemester
            navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
    
    @objc func testsTapped() {
        print("Testy")
        if let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: "testsViewController") as? TestsViewController {
            navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
}
