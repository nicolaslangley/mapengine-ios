//
//  MapViewController.swift
//  MapGame
//
//  Created by Nicolas Langley on 2/11/16.
//  Copyright © 2016 Nicolas Langley. All rights reserved.
//

import MapKit
import MetalKit
import DXCustomCallout_ObjC

extension ViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(NSStringFromClass(DXAnnotationView))
        if (annotationView == nil) {
            let metalView = MetalView(frame: CGRect(x: 0, y: 0, width: 30, height: 30)) as UIView
            let calloutView = CustomCalloutView(frame: CGRect(x: 0, y: 0, width: 30, height: 10)) as UIView
            
            let annotationViewSettings = DXAnnotationSettings.defaultSettings()
            annotationViewSettings.calloutOffset = 5.0
            annotationViewSettings.shouldAddCalloutBorder = false
            
            annotationView = DXAnnotationView(annotation: annotation,
                reuseIdentifier: NSStringFromClass(DXAnnotationView),
                pinView: metalView,
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
        
        if overlay is CustomOverlay {
            print("MapViewDelegate rendererForOverlay function called")
            let overlayView = MetalView(frame: CGRect(x: 0, y: 0, width: 30, height: 30)) as MTKView
            let renderer = MetalOverlayRenderer(overlay: overlay, overlayView: overlayView)
            
            return renderer
        } else if overlay is MKPolyline {
            guard let polyline = overlay as? MKPolyline else {
                return MKOverlayRenderer()
            }
            
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.lineWidth = 1.0
            renderer.alpha = 0.5
            renderer.strokeColor = UIColor.blueColor()
            
            return renderer
        }
        return MKOverlayRenderer()
    }


}
