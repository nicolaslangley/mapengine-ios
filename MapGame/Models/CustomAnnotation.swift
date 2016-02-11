//
//  CustomAnnotation.swift
//  MapGame
//
//  Created by Nicolas Langley on 2/10/16.
//  Copyright © 2016 Nicolas Langley. All rights reserved.
//

import UIKit
import MapKit

enum UnitType: Int {
    case UnitDefault = 0
    case UnitRide
    case UnitFood
    case UnitFirstAid
}

class CustomAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var type: UnitType
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, type: UnitType) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.type = type
    }
}