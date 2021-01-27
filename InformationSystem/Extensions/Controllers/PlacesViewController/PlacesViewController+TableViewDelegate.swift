//
//  PlacesViewController+TableViewDelegate.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 07/04/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit
import EventKit

extension PlacesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        placesArray?[section].array.count ?? 7
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return placesArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "placesCell", for: indexPath) as? PlacesViewControllerCell else { return UITableViewCell()}
            if placesArray != nil {
                cell.hideAnimation()
                if placesArray?[indexPath.section].name == "" {
                    cell.isHidden = true
                }
                cell.nameLabel.text = placesArray?[indexPath.section].name
            }
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "placesDetailCell") as? PlacesDetailCell else { return UITableViewCell()}
            if placesArray != nil {
                cell.hideAnimation()
                
                cell.openView.isHidden = true
                cell.pointsLabel.isHidden = true
                cell.bellView.isHidden = true
                if placesArray?[indexPath.section].array[indexPath.row].isOpened != nil {
                    if (placesArray?[indexPath.section].array[indexPath.row].isOpened)! {
                        cell.openView.backgroundColor = .green
                        cell.openView.isHidden = false
                        cell.bellView.isHidden = true
                    }
                    else {
                        cell.openView.backgroundColor = .red
                        cell.openView.isHidden = false
                        cell.bellView.isHidden = true
                    }
                }
                else {
                    cell.bellView.isHidden = false
                }
                
                if placesArray?[indexPath.section].array[indexPath.row].points != nil {
                    cell.pointsLabel.text = placesArray?[indexPath.section].array[indexPath.row].points!
                    cell.pointsLabel.isHidden = false
                }
                
                cell.nameLabel.text = placesArray?[indexPath.section].array[indexPath.row].name
                cell.time.text = placesArray?[indexPath.section].array[indexPath.row].time
                cell.date.text = placesArray?[indexPath.section].array[indexPath.row].date
                cell.subjectLabel.text = placesArray?[indexPath.section].array[indexPath.row].subject
                cell.teacherLabel.text = placesArray?[indexPath.section].array[indexPath.row].teacher
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
        if placesArray?[indexPath.section].reminders ?? true {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Pridať do kalendára?", message: "Naozaj si želáte pridať udalosť do kalendára? Udalosť bude vytvorená 24 hodín pred uzavretím miesta odovzdania!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Pridať", style: .default, handler: { action in
                    
                    let eventStore = EKEventStore()
                    let time = self.placesArray?[indexPath.section].array[indexPath.row].time
                    let date = self.placesArray?[indexPath.section].array[indexPath.row].date
                    let subject = self.placesArray?[indexPath.section].array[indexPath.row].subject
                    let name = self.placesArray?[indexPath.section].array[indexPath.row].name
                    let finalDate = date! + " " + time!
                    
                    switch EKEventStore.authorizationStatus(for: .event) {
                    case .authorized:
                        self.insertEvent(store: eventStore, date: finalDate, name: name, subject: subject)
                    case .denied:
                        print("Access denied")
                    case .notDetermined:
                        eventStore.requestAccess(to: .event, completion:
                            {[weak self] (granted: Bool, error: Error?) -> Void in
                                if granted {
                                    self!.insertEvent(store: eventStore, date: finalDate, name: name!, subject: subject!)
                                } else {
                                    print("Access denied")
                                }
                        })
                        
                    default:
                        print("Case default")
                    }
                }))
                alert.addAction(UIAlertAction(title: "Zrušiť", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier:"PlacesDownload") as? PlacesDownloadViewController {
                vc.name = placesArray?[indexPath.section].array[indexPath.row].name
                vc.endDate = placesArray?[indexPath.section].array[indexPath.row].date
                vc.teacher = placesArray?[indexPath.section].array[indexPath.row].teacher
                vc.points = placesArray?[indexPath.section].array[indexPath.row].points
                vc.subject = placesArray?[indexPath.section].array[indexPath.row].subject
                vc.detail = placesArray?[indexPath.section].array[indexPath.row].detail
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
