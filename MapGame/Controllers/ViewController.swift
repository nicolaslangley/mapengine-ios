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

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.mapView.delegate = self
        
        self.mapView.mapType = MKMapType.SatelliteFlyover
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444) // Honolulu
        centerMapOnLocation(initialLocation)
        
        // Add test annotation
        let annotation = CustomAnnotation(coordinate: initialLocation.coordinate,
            title: "Test",
            subtitle: "Test Sub",
            type: UnitType.UnitFirstAid)
        mapView.addAnnotation(annotation)
        
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
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    // MARK: MKMapView delegate functions
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? CustomAnnotation {
            let identifier = "pin"
            var view: CustomAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? CustomAnnotationView {
                // Check if reusable annotation is available
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // Use vanilla MKAnnotationView
                view = CustomAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
}

