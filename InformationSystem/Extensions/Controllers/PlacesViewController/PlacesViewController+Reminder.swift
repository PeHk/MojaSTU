//
//  PlacesViewController+Reminder.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 08/04/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import EventKit
import UIKit

extension PlacesViewController {
    func insertEvent(store: EKEventStore, date: String?, name: String?, subject: String?) {
        let calendars = store.calendars(for: .event)
        
        if date != nil && name != nil && subject != nil {
            for calendar in calendars {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy H:mm"
                formatter.timeZone = TimeZone(abbreviation: "UTC")
                let endDate = formatter.date(from: date!)
                let startDate = endDate?.addingTimeInterval(-24 * 60 * 60)
                let event = EKEvent(eventStore: store)
                event.calendar = calendar
                event.title = name!
                event.notes = subject!
                event.startDate = startDate
                event.endDate = endDate
                let alarm:EKAlarm = EKAlarm(relativeOffset: -60)
                event.alarms = [alarm]

                do {
                    try store.save(event, span: .thisEvent)
                    DispatchQueue.main.async {
                        self.showAlertWindow(title: "Úspešne vytvorené", message: "Pripomienka bola úspešne vytvorená!")
                    }
                }
                catch {
                    print("Error saving event in calendar")             }
            }
        }
    }
}
