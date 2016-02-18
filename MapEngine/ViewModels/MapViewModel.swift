//
//  MapViewModel.swift
//  MapGame
//
//  Created by Nicolas Langley on 2/15/16.
//  Copyright © 2016 Nicolas Langley. All rights reserved.
//

import MapKit

class MapViewModel: NSObject {
    
    var currentPathPolyline: MKPolyline = MKPolyline()
    var currentAnnotation: CustomAnnotation!
    var currentAnnotationPosition = 0
    var currentOverlay: CustomOverlay!
    var currentOverlayPosition = 0
    
    var overlays: [CustomOverlay] = []
    var annotations: [CustomAnnotation] = []
    
    var mapCamera: MKMapCamera!
    var coordinateRegion: MKCoordinateRegion!
    var mapType: MKMapType = MKMapType.SatelliteFlyover // Set this in the constructor

    // TODO: Take arguments for camera setup(
    func setupCamera(centerCoordinate: CLLocationCoordinate2D) {
        self.mapCamera = MKMapCamera()
        self.mapCamera.centerCoordinate = centerCoordinate
        self.mapCamera.pitch = 45;
        self.mapCamera.altitude = 500;
        self.mapCamera.heading = 45;
    }

    func addAnnotation(annotation: CustomAnnotation, addAnnotationCallback: (annotation: CustomAnnotation) -> Void) {
        self.annotations.append(annotation)
        addAnnotationCallback(annotation: annotation)
    }

    func addOverlay(overlay: CustomOverlay, addOverlayCallback: (overlay: CustomOverlay) -> Void) {
        self.overlays.append(overlay)
        addOverlayCallback(overlay: overlay)
    }

    func centerMapOnLocation(location: CLLocation, centeringCallback: () -> Void) {
        let regionRadius: CLLocationDistance = 1000
        self.coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        centeringCallback()
    }

    func overlayMapRoute(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D, overlayCallback: () -> Void) {
        let request = MKDirectionsRequest()
        request.transportType = MKDirectionsTransportType.Automobile
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end, addressDictionary: nil))
        
        let directions = MKDirections(request: request)
        directions.calculateDirectionsWithCompletionHandler {
            (response, error) in
            guard let response = response else {
                print("Directions error: \(error)")
                return
            }
            let route = response.routes.first
            self.currentPathPolyline = (route?.polyline)!
            self.currentAnnotationPosition = 0
            overlayCallback()
            self.updateAnnotationPosition()
            self.updateOverlayPosition()
        }
    }

    func updateOverlayPosition() {
        let step = 1
        guard self.currentOverlayPosition + step < self.currentPathPolyline.pointCount
        else { return }

        let points = self.currentPathPolyline.points()
        self.currentOverlayPosition += step
        let nextMapPoint = points[self.currentOverlayPosition]

        self.currentOverlay.coordinate = MKCoordinateForMapPoint(nextMapPoint)
        performSelector("updateOverlayPosition", withObject: nil, afterDelay: 0.1)
    }

    // TODO: (2) Add update position function and movement capability for overlays
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
