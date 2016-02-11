//
//  ViewController.swift
//  MapGame
//
//  Created by Nicolas Langley on 2/9/16.
//  Copyright © 2016 Nicolas Langley. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    let regionRadius: CLLocationDistance = 1000
    var currentCoordinate: CLLocationCoordinate2D?

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.mapView.delegate = self // Current ViewController is the MapDelegate
        
        self.mapView.mapType = MKMapType.SatelliteFlyover
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444) // Honolulu
        currentCoordinate = initialLocation.coordinate
        centerMapOnLocation(initialLocation)
        
        // Add test annotation
        let annotation = CustomAnnotation(coordinate: initialLocation.coordinate,
            title: "Test",
            subtitle: "Test Sub",
            type: UnitType.UnitFirstAid)
        mapView.addAnnotation(annotation)
        
        // TODO: Determine how to retrieve destination based on tap and generate path
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
        // TODO: Make this conform to the CustomAnnotation class
        /*
        let step = 5
        guard planeAnnotationPosition + step < flightpathPolyline.pointCount
            else { return }
        
        let points = flightpathPolyline.points()
        self.planeAnnotationPosition += step
        let nextMapPoint = points[planeAnnotationPosition]
        
        self.planeAnnotation.coordinate = MKCoordinateForMapPoint(nextMapPoint)
        
        performSelector("updatePlanePosition", withObject: nil, afterDelay: 0.03)
        */
    }
    
    // MARK: Helper map functions
    
    @IBAction func revealRegionDetailsWithLongPressOnMap(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.Began { return }
        let touchLocation = sender.locationInView(mapView)
        let locationCoordinate = mapView.convertPoint(touchLocation, toCoordinateFromView: mapView)
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        
        self.mapView.removeOverlays(self.mapView.overlays)
        overlayMapRoute(currentCoordinate!, end: locationCoordinate)
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
            self.mapView.addOverlay((route?.polyline)!, level: MKOverlayLevel.AboveRoads)
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    // MARK: MKMapViewDelegate functions
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? CustomAnnotation {
            let identifier = "custom"
            var view: CustomAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? CustomAnnotationView {
                // Check if reusable annotation is available
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // Create new annotation
                view = CustomAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 3.0
        renderer.alpha = 0.5
        renderer.strokeColor = UIColor.blueColor()
        
        return renderer
    }
    
}

