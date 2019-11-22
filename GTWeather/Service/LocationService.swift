//
//  LocationService.swift
//  GTWeather
//
//  Created by Emmanuel Tugado on 21/11/19.
//  Copyright © 2019 Emmanuel Tugado. All rights reserved.
//

import MapKit
import CoreLocation

protocol LocationServiceDelegate: class {
    func didGetCurrentLocation(_ location: CLLocation)
}

class LocationService: NSObject {
    private var locationManager: CLLocationManager!
    weak var delegate: LocationServiceDelegate?
    
    init(locationManager: CLLocationManager = CLLocationManager(), dataStore: Store = Store()) {
        self.locationManager = locationManager
    }
    
    func start() {
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        
        delegate?.didGetCurrentLocation(currentLocation)
        
        manager.stopUpdatingLocation()
    }
}
