//
//  AttachmentViewController.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 30/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import UIKit

class AttachmentViewController: UIViewController {
//    MARK: Outlets
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var attachmentLabel: UILabel!
    @IBOutlet weak var downloadLabel: UILabel!
    @IBOutlet weak var loadingView: UIView! {
        didSet {
            loadingView.isHidden = true
            loadingView.layer.cornerRadius = 25
        }
    }
    
//    MARK: Variables
    var attachmentArray = [Attachment]()
    let urlsManager = Network()
    var fileURL : URL!
    var notFoundTitle = "Dokument nebol nájdený"
    var notFoundText = "Nastala chyba pri vyhľadávaní dokumentu!"
    var errorTitle = "Niečo sa pokazilo!"
    var errorText = "Prosím skúste znova!"

//    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
        checkObservers()
        tableView.reloadData()
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
       NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .languageSlovak, object: nil)
        NotificationCenter.default.removeObserver(self, name: .languageEnglish, object: nil)
    }
}


