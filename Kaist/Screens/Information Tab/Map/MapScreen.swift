//
//  MapScreen.swift
//  Kaist
//
//  Created by Airat K on 2/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapScreen: AUIMapViewController {
    
    private let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    private var universityBuildingAnnotations: [MKAnnotation] {
        return self.getUniversityBuildings().map {
            UniversityBuildingAnnotation(title: $0["title"]!, subtitle: $0["address"]!, latitude: $0["latitude"]!, longitude: $0["longitude"]!)
        }
    }
    private var currentlyShownUniversityBuildingAnnotations: [MKAnnotation] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        
        self.currentlyShownUniversityBuildingAnnotations = self.universityBuildingAnnotations
        self.setUpSearchController()
        
        self.centerMapViewToMainLocation()
        
        self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: UniversityBuildingAnnotation.reuseID)
        self.mapView.addAnnotations(currentlyShownUniversityBuildingAnnotations)
        
        if CLLocationManager.locationServicesEnabled() {
            self.checkLocationAuthorization()
        }
    }
    
    
    private func setUpSearchController() {
        self.searchController.delegate = self
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.searchBarStyle = .minimal
        self.searchController.searchBar.placeholder = "Найти каёвское здание"
        
        self.navigationItem.titleView = self.searchController.searchBar
        
        self.definesPresentationContext = true
    }
    
    
    private func getUniversityBuildings() -> [[String: Any]] {
        var format = PropertyListSerialization.PropertyListFormat.xml
        
        let pathToUniversityBuildingsData = Bundle.main.path(forResource: "UniversityBuildings", ofType: "plist")!
        let universityBuildingsData = FileManager.default.contents(atPath: pathToUniversityBuildingsData)!
        
        return try! PropertyListSerialization.propertyList(from: universityBuildingsData, options: .mutableContainersAndLeaves, format: &format) as! [[String: Any]]
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
        
        let buildingAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: UniversityBuildingAnnotation.reuseID, for: annotation) as! MKMarkerAnnotationView
        
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
    }
    
}

extension MapScreen: UISearchControllerDelegate {
    
    
    
}

extension MapScreen: UISearchBarDelegate {
    
    
    
}

extension MapScreen: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.mapView.removeAnnotations(self.currentlyShownUniversityBuildingAnnotations)
        
        let strippedSearchQuery = searchController.searchBar.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        //let searchQueryEntities = strippedSearchQuery.components(separatedBy: " ") as [String]
        
        if !strippedSearchQuery.isEmpty {
            self.currentlyShownUniversityBuildingAnnotations = self.universityBuildingAnnotations.filter { $0.title!!.range(of: strippedSearchQuery, options: .caseInsensitive) != nil }
        } else {
            self.currentlyShownUniversityBuildingAnnotations = self.universityBuildingAnnotations
        }
        
        self.mapView.addAnnotations(currentlyShownUniversityBuildingAnnotations)
    }
    
}

extension MapScreen: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.mapView.deselectAnnotation(self.mapView.selectedAnnotations.first, animated: true)
        self.centerMapViewToMainLocation()
    }
    
}
