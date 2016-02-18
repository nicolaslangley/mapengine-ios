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
        self.mapViewModel.centerMapOnLocation(initialLocation) {
            () -> Void in
            self.mapView.setRegion(self.mapViewModel.coordinateRegion, animated: true)
        }
        
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
    
    // TODO: (3) Add selection for map overlays
    @IBAction func revealRegionDetailsWithLongPressOnMap(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.Began { return }
        let touchLocation = sender.locationInView(self.mapView)
        let locationCoordinate = self.mapView.convertPoint(touchLocation, toCoordinateFromView: self.mapView)
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
       
        self.mapView.removeOverlay(self.mapViewModel.currentPathPolyline)
        self.mapViewModel.overlayMapRoute(self.mapViewModel.currentAnnotation.coordinate, end: locationCoordinate) {
            () -> Void in
            // This is a trailing closure
            self.mapView.addOverlay(self.mapViewModel.currentPathPolyline, level: MKOverlayLevel.AboveRoads)
        }
    }
}

