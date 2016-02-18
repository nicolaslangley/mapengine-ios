//
//  MapViewModel.swift
//  MapGame
//
//  Created by Nicolas Langley on 2/15/16.
//  Copyright © 2016 Nicolas Langley. All rights reserved.
//

import MapKit

class MapViewModel: NSObject {
    
    // TODO: (1) Update to MVVM and add ReactiveCocoa for value observation
    var currentPathPolyline: MKPolyline!
    var currentAnnotation: CustomAnnotation!
    var currentAnnotationPosition = 0
    var currentOverlay: CustomOverlay!
    var currentOverlayPosition = 0
    
    var overlays: [CustomOverlay]!
    var annotations: [CustomAnnotation]!
    
    var mapCamera: MKMapCamera!
    var coordinateRegion: MKCoordinateRegion!
    var mapType: MKMapType = MKMapType.SatelliteFlyover // Set this in the constructor
    
    func setupCamera(centerCoordinate: CLLocationCoordinate2D) {
        self.mapCamera = MKMapCamera()
        self.mapCamera.centerCoordinate = centerCoordinate
        self.mapCamera.pitch = 45;
        self.mapCamera.altitude = 500;
        self.mapCamera.heading = 45;
    }
    
    func updateCoordinateRegion(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        self.coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
    }
    
    func updateAnnotationPosition() {
        let step = 1
        guard self.currentAnnotationPosition + step < self.currentPathPolyline.pointCount
            else { return }
        
        let points = self.currentPathPolyline.points()
        self.currentAnnotationPosition += step
        let nextMapPoint = points[self.currentAnnotationPosition]
        
        self.currentAnnotation.coordinate = MKCoordinateForMapPoint(nextMapPoint)
        performSelector("updateAnnotationPosition", withObject: nil, afterDelay: 0.1)
    }
    
}
