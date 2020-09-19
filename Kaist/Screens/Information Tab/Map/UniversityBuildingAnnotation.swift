//
//  UniversityBuildingAnnotation.swift
//  Kaist
//
//  Created by Airat K on 9/8/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit
import MapKit


class UniversityBuildingAnnotation: NSObject, MKAnnotation {
    
    public static let reuseID = "UniversityBuildingAnnotation"
    public static let clusteringID = "UniversityBuildingsCluster"
    
    public var title: String?
    public var subtitle: String?
    public var coordinate: CLLocationCoordinate2D
    
    
    init(title: Any, subtitle: Any, latitude: Any, longitude: Any) {
        self.title = title as? String
        self.subtitle = subtitle as? String
        self.coordinate = CLLocationCoordinate2D(latitude: latitude as! Double, longitude: longitude as! Double)
    }
    
}
