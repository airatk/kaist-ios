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
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let expectedTravelTimeLabel = UILabel()
    private var expectedTravelTimeLabelBottomConstraint = NSLayoutConstraint()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        
        self.setUpSearchController()
        self.setUpExpectedTimeView()
        
        self.centerMapViewToMainLocation()
        
        self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: UniversityBuildingAnnotation.ID)
        self.mapView.addAnnotations(self.getUniversityBuildings().map { UniversityBuildingAnnotation(
            title: $0["title"] as? String, subtitle: $0["address"] as? String,
            coordinate: CLLocationCoordinate2D(latitude: $0["latitude"] as! Double, longitude: $0["longitude"] as! Double)
        )})
        
        if CLLocationManager.locationServicesEnabled() {
            self.checkLocationAuthorization()
        }
    }
    
    
    private func getUniversityBuildings() -> [[String: Any]] {
        var format = PropertyListSerialization.PropertyListFormat.xml
        
        let pathToUniversityBuildingsData = Bundle.main.path(forResource: "UniversityBuildings", ofType: "plist")!
        let universityBuildingsData = FileManager.default.contents(atPath: pathToUniversityBuildingsData)!
        
        return try! PropertyListSerialization.propertyList(from: universityBuildingsData, options: .mutableContainersAndLeaves, format: &format) as! [[String: Any]]
    }
    
    
    private func setUpSearchController() {
        self.searchController.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = true
        
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.searchBarStyle = .minimal
        self.searchController.searchBar.placeholder = "Найти каёвское здание"
        
        self.navigationItem.titleView = self.searchController.searchBar
        
        self.definesPresentationContext = true
    }
    
    private func setUpExpectedTimeView() {
        self.expectedTravelTimeLabel.font = .boldSystemFont(ofSize: 16)
        self.expectedTravelTimeLabel.textAlignment = .center
        self.expectedTravelTimeLabel.textColor = .lightBlue
        
        self.expectedTravelTimeLabel.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        
        self.expectedTravelTimeLabel.layer.borderWidth = 0.5
        self.expectedTravelTimeLabel.layer.borderColor = UIColor.gray.cgColor
        self.expectedTravelTimeLabel.layer.cornerRadius = 10
        self.expectedTravelTimeLabel.clipsToBounds = true
        
        self.mapView.addSubview(self.expectedTravelTimeLabel)
        
        self.expectedTravelTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 75 if expectedTravelTimeLabel.isHidden is true, -15 if expectedTravelTimeLabel.isHidden is false
        self.expectedTravelTimeLabelBottomConstraint = self.expectedTravelTimeLabel.bottomAnchor.constraint(equalTo: self.mapView.safeAreaLayoutGuide.bottomAnchor, constant: 75)
        
        NSLayoutConstraint.activate([
            self.expectedTravelTimeLabelBottomConstraint,
            self.expectedTravelTimeLabel.centerXAnchor.constraint(equalTo: self.mapView.centerXAnchor),
            self.expectedTravelTimeLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30),
            self.expectedTravelTimeLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    private func showexpectedTravelTimeLabel(seconds: TimeInterval, transportType: MKDirectionsTransportType) {
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
        
        self.expectedTravelTimeLabel.text = duration + transport
        self.animateexpectedTravelTimeLabel(toHide: false)
    }
    
    private func hideexpectedTravelTimeLabel() {
        self.animateexpectedTravelTimeLabel(toHide: true)
        self.expectedTravelTimeLabel.text = nil
    }
    
    private func animateexpectedTravelTimeLabel(toHide: Bool) {
        self.expectedTravelTimeLabelBottomConstraint.constant = toHide ? 75 : -15
        
        UIView.animate(withDuration: 0.3) {
            self.mapView.layoutIfNeeded()
        }
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
            
            self.showexpectedTravelTimeLabel(seconds: route.expectedTravelTime, transportType: route.transportType)
            mapView.addOverlay(route.polyline)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.hideexpectedTravelTimeLabel()
        mapView.removeOverlays(mapView.overlays)
    }
    
}

extension MapScreen: UISearchControllerDelegate {
    
    
    
}

extension MapScreen: UISearchBarDelegate {
    
    
    
}

extension MapScreen: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
    
}

extension MapScreen: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.hideexpectedTravelTimeLabel()
        self.mapView.removeOverlays(self.mapView.overlays)
        self.mapView.deselectAnnotation(self.mapView.selectedAnnotations.first, animated: true)
        self.centerMapViewToMainLocation()
    }
    
}
