//
//  ViewController.swift
//  MapGame
//
//  Created by Nicolas Langley on 2/9/16.
//  Copyright © 2016 Nicolas Langley. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var mapViewModel: MapViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.mapViewModel = MapViewModel() // Create ModelView for MVVM
        
        self.mapView.delegate = self // Current ViewController is the MapDelegate
        
        self.mapView.mapType = self.mapViewModel.mapType
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444) // Honolulu
        centerMapOnLocation(initialLocation)
        
        // Add test annotation
        let annotation = CustomAnnotation(coordinate: initialLocation.coordinate,
            title: "Test",
            subtitle: "Test Sub",
            type: UnitType.UnitFirstAid)
        // Add test overlay
        let overlay = CustomOverlay(coordinate: initialLocation.coordinate)
        
        self.mapViewModel.currentAnnotation = annotation
        self.mapView.addAnnotation(self.mapViewModel.currentAnnotation)
        self.mapViewModel.currentOverlay = overlay
        self.mapView.addOverlay(self.mapViewModel.currentOverlay)
        
        // Initial 3D Camera
        self.mapViewModel.setupCamera(initialLocation.coordinate)
        self.mapView.camera = self.mapViewModel.mapCamera;
       
//        let secondCoord = CLLocationCoordinate2D(latitude: 21.28, longitude: -157.829444)
//        let annotation2 = CustomAnnotation(coordinate: secondCoord,
//            title: "Test",
//            subtitle: "Test Sub",
//            type: UnitType.UnitFirstAid)
//        self.mapView.addAnnotation(annotation2)
//        let overlay2 = CustomOverlay(coordinate: secondCoord)
//        self.mapView.addOverlay(overlay2)
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "revealRegionDetailsWithLongPressOnMap:")
        self.view.addGestureRecognizer(gestureRecognizer)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    // TODO: (2) Add update position function and movement capability for overlays
    // TODO: (4) Move updateAnnotationPosition function to MapViewModel class
    
    func updateAnnotationPosition() {
        let step = 1
        guard self.mapViewModel.currentAnnotationPosition + step < self.mapViewModel.currentPathPolyline.pointCount
            else { return }
        
        let points = self.mapViewModel.currentPathPolyline.points()
        self.mapViewModel.currentAnnotationPosition += step
        let nextMapPoint = points[self.mapViewModel.currentAnnotationPosition]
        
        self.mapViewModel.currentAnnotation.coordinate = MKCoordinateForMapPoint(nextMapPoint)
        performSelector("updateAnnotationPosition", withObject: nil, afterDelay: 0.1)
    }
    
    // MARK: Helper map functions
    // TODO: (3) Add selection for map overlays
    
    @IBAction func revealRegionDetailsWithLongPressOnMap(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.Began { return }
        let touchLocation = sender.locationInView(self.mapView)
        let locationCoordinate = self.mapView.convertPoint(touchLocation, toCoordinateFromView: self.mapView)
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
       
        if (self.mapViewModel.currentPathPolyline != nil) {
            self.mapView.removeOverlay(self.mapViewModel.currentPathPolyline)
        }
        overlayMapRoute(self.mapViewModel.currentAnnotation.coordinate, end: locationCoordinate)
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
            self.mapViewModel.currentPathPolyline = (route?.polyline)!
            self.mapViewModel.currentAnnotationPosition = 0
            self.mapView.addOverlay(self.mapViewModel.currentPathPolyline, level: MKOverlayLevel.AboveRoads)
            self.updateAnnotationPosition()
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        self.mapViewModel.updateCoordinateRegion(location)
        self.mapView.setRegion(self.mapViewModel.coordinateRegion, animated: true)
    }
}

