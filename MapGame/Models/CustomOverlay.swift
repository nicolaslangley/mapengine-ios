//
//  CustomOverlay.swift
//  MapGame
//
//  Created by Nicolas Langley on 2/11/16.
//  Copyright © 2016 Nicolas Langley. All rights reserved.
//

import UIKit
import MapKit

class CustomOverlay: NSObject, MKOverlay {

    var coordinate: CLLocationCoordinate2D
    var boundingMapRect: MKMapRect
    
    init(coordinate: CLLocationCoordinate2D, boundingMapRect: MKMapRect) {
        self.boundingMapRect = boundingMapRect
        self.coordinate = coordinate
    }
}