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
    
    private let expectedTravelTimeView = UILabel()
    private var expectedTravelTimeViewTopVariableConstraint = NSLayoutConstraint()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        
        self.navigationController?.navigationBar.isHidden = true
        self.setUpExpectedTimeView()
        
        if CLLocationManager.locationServicesEnabled() {
            self.checkLocationAuthorization()
        }
        
        self.centerMapViewToMainLocation()
        
        let universityBuildingsAnnotations = self.getUniversityBuildings().map {
            UniversityBuildingAnnotation(
                title: $0["title"] as? String, subtitle: $0["address"] as? String,
                coordinate: CLLocationCoordinate2D(latitude: $0["latitude"] as! Double, longitude: $0["longitude"] as! Double)
            )
        }
        self.mapView.addAnnotations(universityBuildingsAnnotations)
        self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: UniversityBuildingAnnotation.ID)
    }
    
    
    private func getUniversityBuildings() -> [[String: Any]] {
        var format = PropertyListSerialization.PropertyListFormat.xml
        
        let pathToUniversityBuildingsData = Bundle.main.path(forResource: "UniversityBuildings", ofType: "plist")!
        let universityBuildingsData = FileManager.default.contents(atPath: pathToUniversityBuildingsData)!
        
        return try! PropertyListSerialization.propertyList(from: universityBuildingsData, options: .mutableContainersAndLeaves, format: &format) as! [[String: Any]]
    }
    
    
    private func setUpExpectedTimeView() {
        self.expectedTravelTimeView.font = .boldSystemFont(ofSize: 16)
        self.expectedTravelTimeView.textAlignment = .center
        self.expectedTravelTimeView.textColor = self.tabBarController?.tabBar.tintColor
        
        self.expectedTravelTimeView.backgroundColor = UIColor.white.withAlphaComponent(0.96)
        
        self.expectedTravelTimeView.layer.borderWidth = 0.5
        self.expectedTravelTimeView.layer.borderColor = UIColor.gray.cgColor
        self.expectedTravelTimeView.layer.cornerRadius = 8
        self.expectedTravelTimeView.clipsToBounds = true
        
        self.mapView.addSubview(self.expectedTravelTimeView)
        
        self.expectedTravelTimeView.translatesAutoresizingMaskIntoConstraints = false
        
        self.expectedTravelTimeViewTopVariableConstraint = self.expectedTravelTimeView.topAnchor.constraint(equalTo: self.mapView.safeAreaLayoutGuide.topAnchor, constant: -75)
        
        NSLayoutConstraint.activate([
            self.expectedTravelTimeViewTopVariableConstraint,
            self.expectedTravelTimeView.centerXAnchor.constraint(equalTo: self.mapView.centerXAnchor),
            self.expectedTravelTimeView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30),
            self.expectedTravelTimeView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    private func showExpectedTravelTimeView(seconds: TimeInterval, transportType: MKDirectionsTransportType) {
        let hours = Int(seconds/3600)
        let minutes = Int(seconds.truncatingRemainder(dividingBy: 3600)/60)
        
        var hoursWord: String {
            switch hours % 10 {
                case 1: return "час"
                case 2, 3, 4: return "часа"
                
                default: return "часов"
            }
        }
        var minutesWord: String{
            switch minutes % 10 {
                case 1: return "минута"
                case 2, 3, 4: return "минуты"
                
                default: return "минут"
            }
        }
        
        var duration: String {
            if hours < 24 {
                return (hours == 0 ? "" : "\(hours) \(hoursWord) ") + (minutes == 0 ? "" : "\(minutes) \(minutesWord) ")
            } else {
                return "Больше суток "
            }
        }
        
        var transport: String {
            switch transportType {
                case .walking: return "пешком"
                case .automobile: return "на машине"
                
                default: return ""
            }
        }
        
        self.expectedTravelTimeView.text = duration + transport
        self.animateExpectedTravelTimeView(toHide: false)
    }
    
    private func hideExpectedTravelTimeView() {
        self.animateExpectedTravelTimeView(toHide: true)
        self.expectedTravelTimeView.text = nil
    }
    
    private func animateExpectedTravelTimeView(toHide: Bool) {
        self.expectedTravelTimeViewTopVariableConstraint.constant = toHide ? -75 : 15
        
        UIView.animate(withDuration: 0.3) { self.mapView.layoutIfNeeded() }
    }
    
    
    private func centerMapViewToMainLocation() {
        let embankmentOfKazanCity = CLLocationCoordinate2D(latitude: 55.8031624, longitude: 49.1152275)
        let region = MKCoordinateRegion(center: embankmentOfKazanCity, latitudinalMeters: 12_000, longitudinalMeters: 12_000)
        
        self.mapView.setRegion(region, animated: true)
    }
    
}

extension MapScreen {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthorization()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        let buildingAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: UniversityBuildingAnnotation.ID, for: annotation) as! MKMarkerAnnotationView
        
        buildingAnnotationView.clusteringIdentifier = UniversityBuildingAnnotation.clusteringID
        
        return buildingAnnotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard !view.annotation!.isKind(of: MKUserLocation.self) else { return }
        
        guard !view.annotation!.isKind(of: MKClusterAnnotation.self) else {
            let zoomCoefficient = 2.5
            
            let region = MKCoordinateRegion(center: view.annotation!.coordinate, span: MKCoordinateSpan(
                latitudeDelta: mapView.region.span.latitudeDelta/zoomCoefficient,
                longitudeDelta: mapView.region.span.longitudeDelta/zoomCoefficient
            ))
            
            mapView.setRegion(region, animated: true)
            mapView.deselectAnnotation(view.annotation, animated: true)
            
            return
        }
        
        let request = MKDirections.Request()
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: view.annotation!.coordinate))
        
        request.transportType = .walking
        
        MKDirections(request: request).calculate { (response, error) in
            guard let route = response?.routes.first, error == nil else { return }
            
            self.showExpectedTravelTimeView(seconds: route.expectedTravelTime, transportType: route.transportType)
            mapView.addOverlay(route.polyline)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.hideExpectedTravelTimeView()
        mapView.removeOverlays(mapView.overlays)
    }
    
}

extension MapScreen: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.hideExpectedTravelTimeView()
        self.mapView.removeOverlays(self.mapView.overlays)
        self.mapView.deselectAnnotation(self.mapView.selectedAnnotations.first, animated: true)
        self.centerMapViewToMainLocation()
    }
    
}
