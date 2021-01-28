//
//  PeopleViewController+Suggest.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 21/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  Extension for handling suggest in search + searchBar

import Foundation
import UIKit

extension PersonViewController {
//    MARK: Text changed
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        timer?.invalidate()
        let text = searchBar.text ?? ""
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        
        if newText == "" {
            peopleArray?.removeAll()
            tableView.reloadData()
            indicator.stopAnimating()
            initial = true
            startSearch.reloadState()
        }

        self.notFound = false
        emptyStateManager.reloadState()
        
        if newText.count > 3 {
            initial = false
            startSearch.reloadState()
            indicator.startAnimating()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(performSearch), userInfo: nil, repeats: false)
        }
        return true;
    }
//    MARK: Send request
    @objc func performSearch() {
        let searchText = searchBar.text!
        let dataBody = "_suggestKey=\(searchText)&upresneni_default=aktivni_a_preruseni,absolventi,zamestnanci,externiste&_suggestMaxItems=25&&subjekt=%32%31%30%31%30&subjekt=%32%31%30%32%30&subjekt=%32%31%30%33%30&subjekt=%32%31%30%34%30&subjekt=%32%31%30%35%30&subjekt=%32%31%30%36%30&subjekt=%32%31%30%37%30&subjekt=%32%31%39%30%30&subjekt=%32%31%39%34%30&subjekt=%32%31%39%35%30&subjekt=%32%31%39%36%30&subjekt=%32%31%39%37%30&subjekt=%32%31%39%38%30&upresneni=%61%6B%74%69%76%6E%69%5F%61%5F%70%72%65%72%75%73%65%6E%69&upresneni=%7A%61%6D%65%73%74%6E%61%6E%63%69&vzorek=&_suggestHandler=lide&lang=\(language)"
    
        DispatchQueue.global().async {
            self.network.postRequest(urlAsString: self.suggestURL, dataToBody: dataBody, completionHandler: {success, statusCode, result in
                if success {
                    if result != nil {
                        self.peopleArray = self.jsonParser.parsePeople(jsonString: result!)
                        DispatchQueue.main.async {
                            self.indicator.stopAnimating()
                            self.tableView.reloadSections([0], with: .automatic)
                            if self.peopleArray?.isEmpty ?? true {
                                self.notFound = true
                                self.emptyStateManager.reloadState()
                            }
                        }
                    }
                }
            })
        }
    }
//    MARK: Handle search button
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text
        if text == nil {
            searchBar.resignFirstResponder()
            indicator.stopAnimating()
            initial = true
            startSearch.reloadState()
            return
        }
        else if text!.count < 3 {
            searchBar.resignFirstResponder()
            indicator.stopAnimating()
            initial = true
            startSearch.reloadState()
            return
        }
    }
}
