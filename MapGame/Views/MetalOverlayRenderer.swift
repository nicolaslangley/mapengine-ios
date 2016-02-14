//
//  CustomMTLOverlayRenderer.swift
//  MapGame
//
//  Created by Nicolas Langley on 2/14/16.
//  Copyright © 2016 Nicolas Langley. All rights reserved.
//

import MapKit
import MetalKit

class MetalOverlayRenderer: MKOverlayRenderer {
    var overlayView: MTKView!
    
    init(overlay: MKOverlay, overlayView: MTKView) {
        self.overlayView = overlayView
        super.init(overlay: overlay)
    }
    
    override func drawMapRect(mapRect: MKMapRect, zoomScale: MKZoomScale, inContext context: CGContext) {
        let imageReference = convertMTLViewToImage(overlayView).CGImage
        let theMapRect = overlay.boundingMapRect
        let theRect = rectForMapRect(theMapRect)
        
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextTranslateCTM(context, 0.0, -theRect.size.height)
        CGContextDrawImage(context, theRect, imageReference)
    }
    
    func convertMTLViewToImage(view: MTKView) -> UIImage {
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
