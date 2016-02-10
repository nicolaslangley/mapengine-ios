//
//  MapOverlay.swift
//  MapGame
//
//  Created by Nicolas Langley on 2/9/16.
//  Copyright © 2016 Nicolas Langley. All rights reserved.
//

import Foundation
import MapKit

class MapOverlay: NSObject, MKOverlay {
    var coordinate: CLLocationCoordinate2D
    var boundingMapRect: MKMapRect
    
    init(coordinate: CLLocationCoordinate2D, boundingMapRect: MKMapRect) {
        self.boundingMapRect = boundingMapRect
        self.coordinate = coordinate
    }
}
