//
//  pdfViewController.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 08/02/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import UIKit
import PDFKit
import Firebase

class PDFViewController: UIViewController, PDFViewDelegate, UIGestureRecognizerDelegate {
//     MARK: Outlets
    @IBOutlet weak var pdfView: PDFView! {
        didSet {
            pdfView.delegate = self
            pdfView.autoScales = true
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(userTapped(_:)))
            pdfView.addGestureRecognizer(tapRecognizer)
            tapRecognizer.delegate = self
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        }
    }
    @IBOutlet weak var thumbnailView: PDFThumbnailView! {
        didSet {
            thumbnailView.thumbnailSize = CGSize(width: 30, height: 30)
            thumbnailView.layoutMode = .vertical
            thumbnailView.pdfView = pdfView
        }
    }

    var pdfURL: URL!
    
//     MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hidesBarsOnTap = true
        NotificationCenter.default.addObserver(self, selector: #selector(numberOfPages), name: .PDFViewPageChanged, object: nil)
        pdfView.bringSubviewToFront(thumbnailView)
        
        if let document = PDFDocument(url: pdfURL) {
            pdfView.document = document
            Analytics.logEvent("pdf_Loaded", parameters: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = false
    }
    
//     MARK: Share button
    @objc func shareTapped() {
        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: pdfURL.path) {
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [pdfURL!], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
            Analytics.logEvent(AnalyticsEventShare, parameters: nil)
        } else {
            showAlertWindow(title: "Dokument nebol nájdený", message: "Nastala chyba pri vyhľadávaní dokumentu!")
        }
    }
    
//      MARK: User tapped
    @objc func userTapped(_: UITapGestureRecognizer) {
        if thumbnailView.isHidden {
            thumbnailView.isHidden = false
            setTabBar(hidden: false)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        else {
            thumbnailView.isHidden = true
            setTabBar(hidden: true)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
//      MARK: Number of pages
    @objc func numberOfPages() {
        let currentPageIndex = pdfView.document?.index(for: pdfView.currentPage!)
        let allPages = pdfView.document?.pageCount
        var finalPages = String()

        if currentPageIndex != nil {
            finalPages = String(currentPageIndex! + 1)
        }
        
        finalPages = finalPages + " z "
        
        if allPages != nil {
            finalPages = finalPages + String(allPages!)
        }
        
        self.navigationItem.title = finalPages
    }
    
    func setTabBar(hidden:Bool) {
        guard let frame = self.tabBarController?.tabBar.frame else {return }
        if hidden {
            UIView.animate(withDuration: 0.3, animations: {
                self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height, width: frame.width, height: frame.height)
            })
        }else {

            UIView.animate(withDuration: 0.3, animations: {
                self.tabBarController?.tabBar.frame = UITabBarController().tabBar.frame

            })
        }
    }
}
