//
//  AKMapViewController.swift
//  kaist
//
//  Created by Airat K on 7/8/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class AKMapViewController: UIViewController, CLLocationManagerDelegate {
    
    public var mapView: MKMapView!
    public var locationManager: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = MKMapView()
        self.mapView = self.view as? MKMapView
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
}
