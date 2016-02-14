//
//  Vertex.swift
//  MapGame
//
//  Created by Nicolas Langley on 2/14/16.
//  Copyright © 2016 Nicolas Langley. All rights reserved.
//

struct Vertex{
    
    var x,y,z: Float     // position data
    var r,g,b,a: Float   // color data
    
    func floatBuffer() -> [Float] {
        return [x,y,z,r,g,b,a]
    }
    
};
