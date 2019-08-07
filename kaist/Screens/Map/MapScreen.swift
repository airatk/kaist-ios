//
//  MapScreen.swift
//  kaist
//
//  Created by Airat K on 2/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapScreen: AKMapViewController {
    
    private let mainBuildingOfIKTZI = CLLocationCoordinate2D(latitude: 55.7964632, longitude: 49.1151588)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        
        self.navigationItem.title = "Здания КАИ"
        
        if CLLocationManager.locationServicesEnabled() {
            self.setUpLocationManager()
        } else {
            // TODO: - Show an alert.
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.mapView.frame = UIScreen.main.bounds
        
        self.centerToMainLocation()
    }
    
    
    private func setUpLocationManager() {
        switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                self.mapView.showsUserLocation = true
            case .denied:
                // TODO: -
                break
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            case .restricted:
                // TODO: -
                break
            
            @unknown default: break
        }
    }
    
    private func centerToMainLocation() {
        let region = MKCoordinateRegion(center: self.mainBuildingOfIKTZI, latitudinalMeters: 10_000, longitudinalMeters: 10_000)
        self.mapView.setRegion(region, animated: true)
    }
    
}

extension MapScreen {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
}

extension MapScreen: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.centerToMainLocation()
    }
    
}
