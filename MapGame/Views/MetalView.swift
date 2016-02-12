//
//  MetalView.swift
//  MapGame
//
//  Created by Nicolas Langley on 2/11/16.
//  Copyright © 2016 Nicolas Langley. All rights reserved.
//

import MetalKit

class MetalView: MTKView {
    
    // TODO: Add 3D rendering and clean up pipeline
    // http://www.raywenderlich.com/81399/ios-8-metal-tutorial-swift-moving-to-3d
    
    var vertexBuffer: MTLBuffer! = nil
    var pipelineState: MTLRenderPipelineState! = nil
    var commandQueue: MTLCommandQueue! = nil
    var timer: CADisplayLink! = nil
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        metalSetup()
    }
    
    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device)
        metalSetup()
    }
    
    func metalSetup() {
        self.colorPixelFormat = .BGRA8Unorm
        self.framebufferOnly = true
        self.device = MTLCreateSystemDefaultDevice()
        createPipelineState()
        let vertexData:[Float] = [
            0.0, 1.0, 0.0,
            -1.0, -1.0, 0.0,
            1.0, -1.0, 0.0]
        createVertexBuffer(vertexData)
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
    
    func createVertexBuffer(vertexData: [Float]) {
        let dataSize = vertexData.count * sizeofValue(vertexData[0])
        vertexBuffer = device!.newBufferWithBytes(vertexData, length: dataSize, options: .CPUCacheModeDefaultCache)
    }
    
    func render() {
        let renderPassDescriptor = MTLRenderPassDescriptor()
        let layer = self.layer as! CAMetalLayer
        let drawable = layer.nextDrawable()
        renderPassDescriptor.colorAttachments[0].texture = drawable!.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .Clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        let commandBuffer = commandQueue.commandBuffer()
        let renderEncoderOpt = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDescriptor)
        let renderEncoder = renderEncoderOpt
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, atIndex: 0)
        renderEncoder.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        renderEncoder.endEncoding()
        
        commandBuffer.presentDrawable(drawable!)
        commandBuffer.commit()
    }
    
    override func drawRect(rect: CGRect) {
        // Called by draw() function
        render()
    }
    
    
}
