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
        self.mapViewModel = MapViewModel()
        self.mapView.delegate = self
        self.mapView.mapType = self.mapViewModel.mapType // Default is SatelliteFlyover

        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444) // Honolulu
        self.mapViewModel.centerMapOnLocation(initialLocation) {
            () -> Void in
            self.mapView.setRegion(self.mapViewModel.coordinateRegion, animated: true)
        }
        
        // Create test annotations and overlays
        let annotation = CustomAnnotation(coordinate: initialLocation.coordinate,
            title: "Test",
            subtitle: "Test Sub",
            type: UnitType.UnitFirstAid)
        let overlay = CustomOverlay(coordinate: initialLocation.coordinate)
        let secondCoord = CLLocationCoordinate2D(latitude: 21.28, longitude: -157.829444)
        let annotation2 = CustomAnnotation(coordinate: secondCoord,
            title: "Test",
            subtitle: "Test Sub",
            type: UnitType.UnitFirstAid)
        let overlay2 = CustomOverlay(coordinate: secondCoord)

        self.mapViewModel.addAnnotation(annotation) {
            (a: CustomAnnotation) -> Void in
            self.mapView.addAnnotation(a)
        }
        self.mapViewModel.addOverlay(overlay) {
            (o: CustomOverlay) -> Void in
            self.mapView.addOverlay(o)
        }
        
        self.mapViewModel.setupCamera(initialLocation.coordinate)
        self.mapView.camera = self.mapViewModel.mapCamera;

        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "revealRegionDetailsWithLongPressOnMap:")
        self.view.addGestureRecognizer(gestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // TODO: Add selection for map overlays
    //       Combine overlays and annotations?
    //       This is handled in the MKMapViewDelegate extension
    @IBAction func revealRegionDetailsWithLongPressOnMap(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.Began { return }
        if self.mapViewModel.currentAnnotation == nil { return }
        let touchLocation = sender.locationInView(self.mapView)
        let locationCoordinate = self.mapView.convertPoint(touchLocation, toCoordinateFromView: self.mapView)
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
       
        self.mapView.removeOverlay(self.mapViewModel.currentPathPolyline)
        self.mapViewModel.overlayMapRoute(self.mapViewModel.currentAnnotation.coordinate, end: locationCoordinate) {
            () -> Void in
            self.mapView.addOverlay(self.mapViewModel.currentPathPolyline, level: MKOverlayLevel.AboveRoads)
        }
    }
}

