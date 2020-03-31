//
//  LocationServices.swift
//  iOS_Restaurants
//
//  Created by Austin Scott on 3/25/20.
//  Copyright © 2020 Austin Scott. All rights reserved.
//

import Foundation
import CoreLocation

enum Result<T>
{
    case success(T)
    case failure(Error)
}

final class LocationServices: NSObject {
    
    private let manager: CLLocationManager
    
    init(manager: CLLocationManager = .init())
    {
        self.manager = manager
        super.init()
        manager.delegate = self
    }
    
    var newLocation: ((Result<CLLocation>) -> Void)?
    var didChangeStatus: ((Bool) -> Void)?
    
    var status: CLAuthorizationStatus
    {
        return CLLocationManager.authorizationStatus()
    }
    
    func requestLocationAuthorization()
    {
        manager.requestWhenInUseAuthorization()
    }
    
    func getLocation()
    {
        manager.requestLocation()
    }
}

extension LocationServices: CLLocationManagerDelegate
{
    //function to deny access to location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        newLocation?(.failure(error))
    }
    
    //function to allow access to location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.sorted(by: {$0.timestamp > $1.timestamp}).first {
            newLocation?(.success(location))
        }
    }
    
    //location access management
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied, .notDetermined:
            didChangeStatus?(false)
        default:
            didChangeStatus?(true)
        }
    }
}
