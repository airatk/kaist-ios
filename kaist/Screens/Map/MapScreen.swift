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
    
    private let universityBuildingsAnnotations = [
        // Educational buildings
        UniversityBuildingAnnotation(
            title: "Первое учебное здание", subtitle: "Карла Маркса, 10",
            coordinate: CLLocationCoordinate2D(latitude: 55.7971077, longitude: 49.1129913)
        ),
        UniversityBuildingAnnotation(
            title: "Второе учебное здание", subtitle: "Четаева, 18",
            coordinate: CLLocationCoordinate2D(latitude: 55.8226860, longitude: 49.1360610)
        ),
        UniversityBuildingAnnotation(
            title: "Третье учебное здание", subtitle: "Толстого, 15",
            coordinate: CLLocationCoordinate2D(latitude: 55.7918200, longitude: 49.1374140)
        ),
        UniversityBuildingAnnotation(
            title: "Четвёртое учебное здание", subtitle: "Горького, 28/17",
            coordinate: CLLocationCoordinate2D(latitude: 55.7931629, longitude: 49.1374294)
        ),
        UniversityBuildingAnnotation(
            title: "Пятое учебное здание", subtitle: "Карла Маркса, 31/7",
            coordinate: CLLocationCoordinate2D(latitude: 55.7969110, longitude: 49.1237459)
        ),
        UniversityBuildingAnnotation(
            title: "Шестое учебное здание", subtitle: "Дементьева, 2а",
            coordinate: CLLocationCoordinate2D(latitude: 55.8542530, longitude: 49.0980440)
        ),
        UniversityBuildingAnnotation(
            title: "Седьмое учебное здание", subtitle: "Большая Красная, 55",
            coordinate: CLLocationCoordinate2D(latitude: 55.7971410, longitude: 49.1345289)
        ),
        UniversityBuildingAnnotation(
            title: "Восьмое учебное здание", subtitle: "Четаева, 18а",
            coordinate: CLLocationCoordinate2D(latitude: 55.8208035, longitude: 49.1363205)
        ),
        
        // Sports Complex
        UniversityBuildingAnnotation(
            title: "СК «Олимп»", subtitle: "Чистопольская, 65",
            coordinate: CLLocationCoordinate2D(latitude: 55.8201111, longitude: 49.1398743)
        ),
        UniversityBuildingAnnotation(
            title: "Бассейн «Олимп»", subtitle: "Чистопольская, 65",
            coordinate: CLLocationCoordinate2D(latitude: 55.821139, longitude: 49.1402243)
        ),
        UniversityBuildingAnnotation(
            title: "Стадион «Олимп»", subtitle: "Чистопольская, 65",
            coordinate: CLLocationCoordinate2D(latitude: 55.821703, longitude: 49.140717)
        ),
        
        // Dormitories
        UniversityBuildingAnnotation(
            title: "Общежитие №1", subtitle: "Большая Красная, 7/9",
            coordinate: CLLocationCoordinate2D(latitude: 55.7984276, longitude: 49.1154430)
        ),
        UniversityBuildingAnnotation(
            title: "Общежитие №2", subtitle: "Большая Красная, 18",
            coordinate: CLLocationCoordinate2D(latitude: 55.7978831, longitude: 49.1147940)
        ),
        UniversityBuildingAnnotation(
            title: "Общежитие №3", subtitle: "Кирпичникова, 11",
            coordinate: CLLocationCoordinate2D(latitude: 55.8095929, longitude: 49.1998827)
        ),
        UniversityBuildingAnnotation(
            title: "Общежитие №4", subtitle: "Короленко, 85",
            coordinate: CLLocationCoordinate2D(latitude: 55.8379590, longitude: 49.1009150)
        ),
        UniversityBuildingAnnotation(
            title: "Общежитие №5", subtitle: "Ершова, 30",
            coordinate: CLLocationCoordinate2D(latitude: 55.7927011, longitude: 49.1644210)
        ),
        UniversityBuildingAnnotation(
            title: "Общежитие №6", subtitle: "Товарищеская, 30",
            coordinate: CLLocationCoordinate2D(latitude: 55.7851918, longitude: 49.1559488)
        ),
        UniversityBuildingAnnotation(
            title: "Общежитие №7", subtitle: "Товарищеская, 30а",
            coordinate: CLLocationCoordinate2D(latitude: 55.7853090, longitude: 49.1549720)
        )
    ]
    
    private let expectedTravelTimeView = UILabel()
    private var expectedTravelTimeViewTopConstraint = NSLayoutConstraint()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        
        self.navigationController?.navigationBar.isHidden = true
        self.setUpExpectedTimeView()
        
        if CLLocationManager.locationServicesEnabled() {
            self.checkLocationAuthorization()
        }
        
        self.centerMapViewToMainLocation(animated: false)
        
        self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: UniversityBuildingAnnotation.ID)
        self.mapView.addAnnotations(universityBuildingsAnnotations)
    }
    
    
    private func setUpExpectedTimeView() {
        self.expectedTravelTimeView.font = .boldSystemFont(ofSize: 16)
        self.expectedTravelTimeView.textAlignment = .center
        self.expectedTravelTimeView.textColor = self.tabBarController?.tabBar.tintColor
        
        self.expectedTravelTimeView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        
        self.expectedTravelTimeView.layer.borderWidth = 0.4
        self.expectedTravelTimeView.layer.borderColor = UIColor.gray.cgColor
        self.expectedTravelTimeView.layer.cornerRadius = 8
        self.expectedTravelTimeView.clipsToBounds = true
        
        self.mapView.addSubview(self.expectedTravelTimeView)
        
        self.expectedTravelTimeView.translatesAutoresizingMaskIntoConstraints = false
        
        self.expectedTravelTimeViewTopConstraint = self.expectedTravelTimeView.topAnchor.constraint(equalTo: self.mapView.safeAreaLayoutGuide.topAnchor, constant: -75)
        
        NSLayoutConstraint.activate([
            self.expectedTravelTimeViewTopConstraint,
            self.expectedTravelTimeView.centerXAnchor.constraint(equalTo: self.mapView.centerXAnchor),
            self.expectedTravelTimeView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30),
            self.expectedTravelTimeView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func showExpectedTravelTimeView(seconds: TimeInterval, transportType: MKDirectionsTransportType) {
        let hoursNumber = Int(seconds/3600)
        let minutesNumber = Int(seconds.truncatingRemainder(dividingBy: 3600)/60)
        
        var hoursWord: String {
            switch hoursNumber % 10 {
                case 1: return "час"
                case 2, 3, 4: return "часа"
                
                default: return "часов"
            }
        }
        var minutesWord: String{
            switch minutesNumber % 10 {
                case 1: return "минута"
                case 2, 3, 4: return "минуты"
                
                default: return "минут"
            }
        }
        
        var time: String {
            if hoursNumber < 24 {
                return (hoursNumber == 0 ? "" : "\(hoursNumber) \(hoursWord) ") +
                    (minutesNumber == 0 ? "" : "\(minutesNumber) \(minutesWord) ")
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
        
        self.expectedTravelTimeView.text = time + transport
        self.animateExpectedTravelTimeView(toHide: false)
    }
    
    private func hideExpectedTravelTimeView() {
        self.animateExpectedTravelTimeView(toHide: true)
        self.expectedTravelTimeView.text = nil
    }
    
    private func animateExpectedTravelTimeView(toHide: Bool) {
        if toHide {
            self.expectedTravelTimeViewTopConstraint.constant = -75
        } else {
            self.expectedTravelTimeViewTopConstraint.constant = 15
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.mapView.layoutIfNeeded()
        })
    }
    
    
    private func centerMapViewToMainLocation(animated: Bool) {
        let embankmentOfKazanCity = CLLocationCoordinate2D(latitude: 55.8031624, longitude: 49.1152275)
        let region = MKCoordinateRegion(center: embankmentOfKazanCity, latitudinalMeters: 12_000, longitudinalMeters: 12_000)
        
        self.mapView.setRegion(region, animated: animated)
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
        
        request.transportType = .walking
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: view.annotation!.coordinate))
        
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in
            guard let route = response?.routes.first, error == nil else { return }
            
            self.showExpectedTravelTimeView(seconds: route.expectedTravelTime, transportType: route.transportType)
            self.mapView.addOverlay(route.polyline)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.hideExpectedTravelTimeView()
        self.mapView.removeOverlays(self.mapView.overlays)
    }
    
}

extension MapScreen: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.hideExpectedTravelTimeView()
        
        self.mapView.removeOverlays(self.mapView.overlays)
        self.mapView.deselectAnnotation(self.mapView.selectedAnnotations.first, animated: true)
        
        self.centerMapViewToMainLocation(animated: true)
    }
    
}
