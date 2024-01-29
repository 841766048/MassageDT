//
//  LocationManager.swift
//  MassageDT
//
//  Created by 张海彬 on 2024/1/25.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private var locationManager: CLLocationManager
    
    var currentLocation: CLLocation?
    var locationUpdateCompletion: ((CLLocation?) -> Void)?

    private override init() {
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation(completion: ((CLLocation?) -> Void)? = nil) {
        locationUpdateCompletion = completion
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationUpdateCompletion = nil
    }

    func hasLocationAuthorization() -> Bool {
        if #available(iOS 14.0, *) {
            return locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways
        } else {
            return CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            locationUpdateCompletion?(location)
            print("Current Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager Error: \(error.localizedDescription)")
        locationUpdateCompletion?(nil)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Handle authorization status changes if needed
    }
}
