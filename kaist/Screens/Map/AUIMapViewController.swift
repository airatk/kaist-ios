//
//  AUIMapViewController.swift
//  kaist
//
//  Created by Airat K on 7/8/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class AUIMapViewController: UIViewController, CLLocationManagerDelegate {
    
    public var mapView: MKMapView!
    public var locationManager: CLLocationManager!
    
    
    override func loadView() {
        self.view = MKMapView()
        self.mapView = self.view as? MKMapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                self.mapView.showsUserLocation = true
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            case .denied, .restricted:
                break
        
            @unknown default: break
        }
    }
    
}

extension AUIMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = .lightBlue
        
        return renderer
    }
    
}
