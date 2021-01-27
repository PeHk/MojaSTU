//
//  SceneDelegate+CLLocationDelegate.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 20/06/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import Solar
import UIKit
import CoreLocation

extension SceneDelegate: CLLocationManagerDelegate {
    func retriveCurrentLocation(){
        let status = CLLocationManager.authorizationStatus()
        
        if(status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled()){
            // show alert to user telling them they need to allow location data to use some feature of your app
            return
        }
        
        // if haven't show location permission dialog before, show it to user
        if(status == .notDetermined) {
            
            locationManager.requestWhenInUseAuthorization()
            
            // if you want the app to retrieve location data even in background, use requestAlwaysAuthorization
            // locationManager.requestAlwaysAuthorization()
            return
        }
        
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // .requestLocation will only pass one location to the locations array
        // hence we can access it by taking the first element of the array
        
        let currentLoc = locationManager.location
        if currentLoc != nil {
            let solar = Solar(coordinate: CLLocationCoordinate2D(latitude: currentLoc!.coordinate.latitude, longitude: currentLoc!.coordinate.longitude))
            var sunrise = solar?.sunrise
            var sunset = solar?.sunset
            var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
            let currentTime = Date().addingTimeInterval(Double(secondsFromGMT))
            
            if sunset != nil && sunrise != nil {
                sunset = sunset!.addingTimeInterval(Double(secondsFromGMT))
                sunrise = sunrise!.addingTimeInterval(Double(secondsFromGMT))
                
                if currentTime > sunset! {
                    UserDefaults.standard.set(true, forKey: "darkModeEnabled")
                    NotificationCenter.default.post(name: .darkModeEnabled, object: nil)
                    locationManager.stopUpdatingLocation()
                }
                else if currentTime > sunrise! {
                    UserDefaults.standard.set(false, forKey: "darkModeEnabled")
                    NotificationCenter.default.post(name: .darkModeDisabled, object: nil)
                    locationManager.stopUpdatingLocation()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // might be that user didn't enable location service on the device
        // or there might be no GPS signal inside a building
        
        // might be a good idea to show an alert to user to ask them to walk to a place with GPS signal
    }
}
