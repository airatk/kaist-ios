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
    
    private var areBarsHidden: Bool = false
    
    
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
        
        self.mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideBars)))
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
    
    
    @objc private func hideBars() {
        guard let navBar = self.navigationController?.navigationBar else { return }
        guard let tabBar = self.tabBarController?.tabBar else { return }
        
        let barHeight = navBar.frame.height + UIApplication.shared.statusBarFrame.height
        let barOffset = self.areBarsHidden ? -barHeight : barHeight
        
        UIView.animate(withDuration: 0.25, delay: 0.1, animations: {
            navBar.frame = navBar.frame.offsetBy(dx: 0, dy: -barOffset)
            tabBar.frame = tabBar.frame.offsetBy(dx: 0, dy: barOffset)
        }, completion: { (_) in
            self.areBarsHidden = !self.areBarsHidden
        })
    }
    
}

extension AUIMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = .lightBlue
        
        return renderer
    }
    
}
