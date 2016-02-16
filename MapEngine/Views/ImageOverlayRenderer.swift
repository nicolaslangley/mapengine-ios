//
//  CustomOverlayView.swift
//  MapGame
//
//  Created by Nicolas Langley on 2/11/16.
//  Copyright © 2016 Nicolas Langley. All rights reserved.
//

import UIKit
import MapKit

class ImageOverlayRenderer: MKOverlayRenderer {
    var overlayImage: UIImage?
    
    init(overlay: MKOverlay, overlayImage: UIImage) {
        self.overlayImage = overlayImage
        super.init(overlay: overlay)
    }
    
    override func drawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext) {
        let imageReference = overlayImage!.CGImage
        let theMapRect = overlay.boundingMapRect
        let theRect = rectForMapRect(theMapRect)
        
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextTranslateCTM(context, 0.0, -theRect.size.height)
        CGContextDrawImage(context, theRect, imageReference)
    }
}
