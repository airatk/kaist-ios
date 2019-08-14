//
//  UniversityBuildingAnnotation.swift
//  kaist
//
//  Created by Airat K on 9/8/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit
import MapKit


class UniversityBuildingAnnotation: NSObject, MKAnnotation {
    
    public static let ID = "UniversityBuildingAnnotation"
    public static let clusteringID = "UniversityBuildingsCluster"
    
    public var title: String?
    public var subtitle: String?
    public var coordinate: CLLocationCoordinate2D
    
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
}
