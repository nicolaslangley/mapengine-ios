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

        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTapOnMap:")
        self.view.addGestureRecognizer(tapRecognizer)

        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPressOnMap:")
        self.view.addGestureRecognizer(gestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // TODO: Add selection for map overlays
    //       Combine overlays and annotations?
    //       This is handled in the MKMapViewDelegate extension
    @IBAction func handleLongPressOnMap(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.Began { return }
        if self.mapViewModel.currentAnnotation == nil { return }
        let touchLocation = sender.locationInView(self.mapView)
        let locationCoordinate = self.mapView.convertPoint(touchLocation, toCoordinateFromView: self.mapView)
        print("Long press at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")

        self.mapView.removeOverlay(self.mapViewModel.currentPathPolyline)
        self.mapViewModel.overlayMapRoute(self.mapViewModel.currentAnnotation.coordinate, end: locationCoordinate) {
            () -> Void in
            self.mapView.addOverlay(self.mapViewModel.currentPathPolyline, level: MKOverlayLevel.AboveRoads)
        }
    }

    @IBAction func handleTapOnMap(sender: UITapGestureRecognizer) {
        if sender.state != .Ended { return }
        let touchLocation = sender.locationInView(self.mapView)
        let locationCoordinate = self.mapView.convertPoint(touchLocation, toCoordinateFromView: self.mapView)
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        let tapPoint = MKMapPointForCoordinate(locationCoordinate)

        for overlay in self.mapViewModel.overlays {
            let overlayMapRect = overlay.boundingMapRect
            if MKMapRectContainsPoint(overlayMapRect, tapPoint) {
                self.mapViewModel.selectOverlay(overlay)
                print("Overlay Selected")
            }
        }
    }

    func MKMapRectForCoordinateRegion(region:MKCoordinateRegion) -> MKMapRect {
        let topLeft = CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta/2), longitude: region.center.longitude - (region.span.longitudeDelta/2))
        let bottomRight = CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta/2), longitude: region.center.longitude + (region.span.longitudeDelta/2))

        let a = MKMapPointForCoordinate(topLeft)
        let b = MKMapPointForCoordinate(bottomRight)

        return MKMapRect(origin: MKMapPoint(x:min(a.x,b.x), y:min(a.y,b.y)), size: MKMapSize(width: abs(a.x-b.x), height: abs(a.y-b.y)))
    }
}

