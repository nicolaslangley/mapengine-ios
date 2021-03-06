//
//  MetalView.swift
//  MapGame
//
//  Created by Nicolas Langley on 2/11/16.
//  Copyright © 2016 Nicolas Langley. All rights reserved.
//

import MetalKit
import GLKit

class MetalView: MTKView {
    
    var objectToDraw: Node!
    var pipelineState: MTLRenderPipelineState! = nil
    var commandQueue: MTLCommandQueue! = nil
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        metalSetup()
    }
    
    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device)
        metalSetup()
    }
    
    func metalSetup() {
        self.device = MTLCreateSystemDefaultDevice()
        self.colorPixelFormat = .BGRA8Unorm
        self.framebufferOnly = true
        self.paused = false
        self.enableSetNeedsDisplay = false
        
        createPipelineState()
        objectToDraw = Cube(device: self.device!)
        commandQueue = device?.newCommandQueue()
    }
    
    func createPipelineState() {
        let defaultLibrary = device!.newDefaultLibrary()
        let fragmentProgram = defaultLibrary!.newFunctionWithName("basic_fragment")
        let vertexProgram = defaultLibrary!.newFunctionWithName("basic_vertex")
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm

        do {
            try pipelineState = device?.newRenderPipelineStateWithDescriptor(pipelineStateDescriptor)
        } catch {
            print("Failed to create pipeline state")
        }
    }
    
    override func drawRect(rect: CGRect) {
        let layer = self.layer as! CAMetalLayer
        let drawable = layer.nextDrawable()
        
        objectToDraw.positionX = -0.25
        objectToDraw.rotationZ = GLKMathDegreesToRadians(45)
        objectToDraw.scale = 0.9
        objectToDraw.render(commandQueue, pipelineState: pipelineState, drawable: drawable!, clearColor: nil)
    }
    
    
}
