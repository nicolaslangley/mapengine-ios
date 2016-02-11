//
//  ViewController.swift
//  MapGame
//
//  Created by Nicolas Langley on 2/9/16.
//  Copyright © 2016 Nicolas Langley. All rights reserved.
//

import UIKit
import MapKit
import DXCustomCallout_ObjC

class ViewController: UIViewController, MKMapViewDelegate {
    
    let regionRadius: CLLocationDistance = 1000
    
    var currentPathPolyline: MKPolyline!
    var currentAnnotation: CustomAnnotation!
    var currentAnnotationPosition = 0

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.mapView.delegate = self // Current ViewController is the MapDelegate
        
        self.mapView.mapType = MKMapType.SatelliteFlyover
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444) // Honolulu
        centerMapOnLocation(initialLocation)
        
        // Add test annotation
        let annotation = CustomAnnotation(coordinate: initialLocation.coordinate,
            title: "Test",
            subtitle: "Test Sub",
            type: UnitType.UnitFirstAid)
        self.mapView.addAnnotation(annotation)
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "revealRegionDetailsWithLongPressOnMap:")
        self.view.addGestureRecognizer(gestureRecognizer)
        
        // Initial 3D Camera
        let mapCamera = MKMapCamera()
        mapCamera.centerCoordinate = initialLocation.coordinate
        mapCamera.pitch = 45;
        mapCamera.altitude = 500;
        mapCamera.heading = 45;
        self.mapView.camera = mapCamera;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateAnnotationPosition() {
        let step = 1
        guard currentAnnotationPosition + step < currentPathPolyline.pointCount
            else { return }
        
        let points = currentPathPolyline.points()
        self.currentAnnotationPosition += step
        let nextMapPoint = points[currentAnnotationPosition]
        
        self.currentAnnotation.coordinate = MKCoordinateForMapPoint(nextMapPoint)
        performSelector("updateAnnotationPosition", withObject: nil, afterDelay: 0.1)
    }
    
    // MARK: Helper map functions
    
    @IBAction func revealRegionDetailsWithLongPressOnMap(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.Began { return }
        if currentAnnotation == nil { return }
        let touchLocation = sender.locationInView(self.mapView)
        let locationCoordinate = self.mapView.convertPoint(touchLocation, toCoordinateFromView: self.mapView)
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        
        self.mapView.removeOverlays(self.mapView.overlays)
        overlayMapRoute(self.currentAnnotation.coordinate, end: locationCoordinate)
    }
    
    func overlayMapRoute(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) {
        let request = MKDirectionsRequest()
        request.transportType = MKDirectionsTransportType.Automobile
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end, addressDictionary: nil))
        
        let directions = MKDirections(request: request)
        directions.calculateDirectionsWithCompletionHandler { response, error in
            guard let response = response else {
                print("Directions error: \(error)")
                return
            }
            let route = response.routes.first
            self.currentPathPolyline = (route?.polyline)!
            self.currentAnnotationPosition = 0
            self.mapView.addOverlay(self.currentPathPolyline, level: MKOverlayLevel.AboveRoads)
            self.updateAnnotationPosition()
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }

    // MARK: MKMapViewDelegate functions
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(NSStringFromClass(DXAnnotationView))
        if (annotationView == nil) {
            let pinView = CustomAnnotationView(frame: CGRect(x: 0, y: 0, width: 30, height: 30)) as UIView
            let calloutView = CustomCalloutView(frame: CGRect(x: 0, y: 0, width: 30, height: 10)) as UIView
            
            let annotationViewSettings = DXAnnotationSettings.defaultSettings()
            annotationViewSettings.calloutOffset = 5.0
            annotationViewSettings.shouldAddCalloutBorder = false
            
            annotationView = DXAnnotationView(annotation: annotation,
                reuseIdentifier: NSStringFromClass(DXAnnotationView),
                pinView: pinView,
                calloutView: calloutView,
                settings: annotationViewSettings)
        }
        return annotationView

    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        currentAnnotation = view.annotation as! CustomAnnotation
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        currentAnnotation = nil
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 1.0
        renderer.alpha = 0.5
        renderer.strokeColor = UIColor.blueColor()
        
        return renderer
    }
    
}

