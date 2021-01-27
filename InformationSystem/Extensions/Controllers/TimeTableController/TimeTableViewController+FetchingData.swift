//
//  TimeTableViewController+FetchingData.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 01/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//
//  This extension is for refreshing data in table view on swipe or button click

import Foundation
import UIKit

extension TimeTableController {
//    MARK: Fetching next data
    func fetchNextDay(){
        tableView.tableFooterView = UIView()
        
        if indexOfCurrentDay >= 6 {
            indexOfCurrentDay = 0
        } else {
            indexOfCurrentDay += 1
        }
        
        if indexOfDay >= 7 {
            indexOfDay = 1
        }
        else {
            indexOfDay += 1
        }
        let nextDate = Calendar.current.date(byAdding: .day, value: indexOfCurrentDay, to: currentDate)!
        let currentDateString = dateFormatter.string(from: nextDate)
        dateLabel.text = currentDateString
        timeTableDay.text = nameOfDays[indexOfDay]
        
        jsonparser.parseTimeTable(dayOfWeek: String(indexOfDay - 1))
        daySubjects = [TimeTableSubject]()
        daySubjects = jsonparser.sortedDaySubjects
        
        if currentDay == indexOfDay - 1 {
            showAnimated(in: mainStack)
        }
        else {
            hideAnimated(in: mainStack)
        }
    
        addAnimationToRight()
        tableView.reloadData()
        checkScroll()
        
        self.noSubjects.reloadState()
    }
    
//      MARK: Fetching previous data
    func fetchPreviousDay(){
        tableView.tableFooterView = UIView()
        if indexOfCurrentDay <= -6 {
            indexOfCurrentDay = 0
        } else {
            indexOfCurrentDay -= 1
        }
        
        if indexOfDay <= 1 {
            indexOfDay = 7
        }
        else {
            indexOfDay -= 1
        }
        let nextDate = Calendar.current.date(byAdding: .day, value: indexOfCurrentDay, to: currentDate)!
        let currentDateString = dateFormatter.string(from: nextDate)
        dateLabel.text = currentDateString
        timeTableDay.text = nameOfDays[indexOfDay]
        jsonparser.parseTimeTable(dayOfWeek: String(indexOfDay - 1))
        daySubjects = [TimeTableSubject]()
        daySubjects = jsonparser.sortedDaySubjects
        
        if currentDay == indexOfDay - 1 {
            showAnimated(in: mainStack)
        }
        else {
            hideAnimated(in: mainStack)
        }
        
        
        addAnimationToLeft()
        tableView.reloadData()
        checkScroll()
        
        self.noSubjects.reloadState()
    }
    
//    MARK: isScrollable
    func checkScroll() {
        var height: CGFloat = 0
        for cell in tableView.visibleCells {
            height += cell.bounds.height
        }

        if (height < tableView.frame.size.height) {
            self.tableView.isScrollEnabled = false;
        }
        else {
            self.tableView.isScrollEnabled = true;
        }
    }
    
    func showAnimated(in stackView: UIStackView) {
        if nameDayLabel.isHidden {
            UILabel.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.nameDayLabel.isHidden = false
                    stackView.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }
    
    func hideAnimated(in stackView: UIStackView) {
        if !nameDayLabel.isHidden {
            UILabel.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.nameDayLabel.isHidden = true
                    stackView.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }
    
//    func hideView() {
//        UIView.animate(withDuration: 0.2, animations: {
//            self.nameDayLabel.alpha = 0
//        }) { (finished) in
//            self.nameDayLabel.isHidden = finished
//        }
//    }

}
