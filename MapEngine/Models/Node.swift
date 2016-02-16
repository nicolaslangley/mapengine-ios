//
//  Node.swift
//  MapGame
//
//  Created by Nicolas Langley on 2/14/16.
//  Copyright © 2016 Nicolas Langley. All rights reserved.
//

import Foundation
import MetalKit
import GLKit

class Node {
    
    let name: String
    var vertexCount: Int
    var vertexBuffer: MTLBuffer
    var uniformBuffer: MTLBuffer?
    var device: MTLDevice
    
    var positionX:Float = 0.0
    var positionY:Float = 0.0
    var positionZ:Float = 0.0
    
    var rotationX:Float = 0.0
    var rotationY:Float = 0.0
    var rotationZ:Float = 0.0
    var scale:Float     = 1.0
    
    init(name: String, vertices: Array<Vertex>, device: MTLDevice) {
        var vertexData = Array<Float>()
        for vertex in vertices{
            vertexData += vertex.floatBuffer()
        }
        
        let dataSize = vertexData.count * sizeofValue(vertexData[0])
        vertexBuffer = device.newBufferWithBytes(vertexData, length: dataSize, options: .CPUCacheModeDefaultCache)
        
        self.name = name
        self.device = device
        vertexCount = vertices.count
    }
    
    func render(commandQueue: MTLCommandQueue, pipelineState: MTLRenderPipelineState, drawable: CAMetalDrawable, clearColor: MTLClearColor?) {
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .Clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        renderPassDescriptor.colorAttachments[0].storeAction = .Store
        
        let commandBuffer = commandQueue.commandBuffer()
        let renderEncoderOpt = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDescriptor)
        let renderEncoder = renderEncoderOpt
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, atIndex: 0)
       
        // FIXME: (1) Continuously allocating memory each frame is expensive and not recommended in production apps
        var nodeModelMatrix = self.modelMatrix()
        uniformBuffer = device.newBufferWithLength(sizeof(Float)*16, options: .CPUCacheModeDefaultCache)
        let bufferPointer = uniformBuffer?.contents()
        memcpy(bufferPointer!, &(nodeModelMatrix.m), sizeof(Float)*16)
        renderEncoder.setVertexBuffer(self.uniformBuffer, offset: 0, atIndex: 1)
        
        renderEncoder.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        renderEncoder.endEncoding()
        
        commandBuffer.presentDrawable(drawable)
        commandBuffer.commit()
    }
    
    func modelMatrix() -> GLKMatrix4 {
        var matrix = GLKMatrix4Identity
        matrix = GLKMatrix4Translate(matrix, positionX, positionY, positionZ)
        matrix = GLKMatrix4Rotate(matrix, rotationX, 1, 0, 0)
        matrix = GLKMatrix4Rotate(matrix, rotationY, 0, 1, 0)
        matrix = GLKMatrix4Rotate(matrix, rotationZ, 0, 0, 1)
        matrix = GLKMatrix4Scale(matrix, scale, scale, scale)
        return matrix
    }
}
