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
    var overlayTopLeftCoordinate: CLLocationCoordinate2D
    var overlayTopRightCoordinate: CLLocationCoordinate2D
    var overlayBottomLeftCoordinate: CLLocationCoordinate2D
    var overlayBottomRightCoordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(overlayBottomLeftCoordinate.latitude,
                overlayTopRightCoordinate.longitude)
        }
    }
    var boundingMapRect: MKMapRect {
        get {
            let topLeft = MKMapPointForCoordinate(overlayTopLeftCoordinate)
            let topRight = MKMapPointForCoordinate(overlayTopRightCoordinate)
            let bottomLeft = MKMapPointForCoordinate(overlayBottomLeftCoordinate)
            
            return MKMapRectMake(topLeft.x,
                topLeft.y,
                fabs(topLeft.x-topRight.x),
                fabs(topLeft.y - bottomLeft.y))
        }
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        let boundarySize = 0.0003
        let boundaryOffset = (boundarySize / 2.0)
        overlayTopLeftCoordinate = CLLocationCoordinate2D(
            latitude: coordinate.latitude + boundaryOffset,
            longitude: coordinate.longitude - boundaryOffset)
        overlayTopRightCoordinate = CLLocationCoordinate2D(
            latitude: coordinate.latitude + boundaryOffset,
            longitude: coordinate.longitude + boundaryOffset)
        overlayBottomLeftCoordinate = CLLocationCoordinate2D(
            latitude: coordinate.latitude - boundaryOffset,
            longitude: coordinate.longitude - boundaryOffset)
    }
}