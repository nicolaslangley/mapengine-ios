//
//  CustomOverlayView.swift
//  MapGame
//
//  Created by Nicolas Langley on 2/11/16.
//  Copyright © 2016 Nicolas Langley. All rights reserved.
//

import UIKit
import MapKit

class CustomOverlayRenderer: MKOverlayRenderer {
    var overlayImage: UIImage?
    var overlayView: UIView!
    
    init(overlay: MKOverlay, overlayImage: UIImage) {
        self.overlayImage = overlayImage
        super.init(overlay: overlay)
    }
    
    init(overlay: MKOverlay, overlayView: UIView) {
        self.overlayView = overlayView
        super.init(overlay: overlay)
    }
    
    override func drawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext) {
        if (overlayView != nil) {
            if let metalView = overlayView as? MetalView {
                overlayImage = convertMTLViewToImage(metalView)
            }
        }
        let imageReference = overlayImage!.CGImage
        
        let theMapRect = overlay.boundingMapRect
        let theRect = rectForMapRect(theMapRect)
        
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextTranslateCTM(context, 0.0, -theRect.size.height)
        CGContextDrawImage(context, theRect, imageReference)
    }
    
    
    func convertMTLViewToImage(view: MetalView) -> UIImage {
        let texture = view.currentDrawable!.texture
        let textureCIImage = CIImage(MTLTexture: texture, options: nil)
        let textureCGImage = convertCIImageToCGImage(textureCIImage)
        let image = UIImage(CGImage: textureCGImage)
        return image
    }
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
        let context = CIContext(options: nil)
        return context.createCGImage(inputImage, fromRect: inputImage.extent)
    }
}
