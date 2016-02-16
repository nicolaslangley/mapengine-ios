//
//  Shaders.metal
//  MapGame
//
//  Created by Nicolas Langley on 2/11/16.
//  Copyright © 2016 Nicolas Langley. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn
{
    packed_float3 position;
    packed_float4 color;
};

struct VertexOut
{
    float4 position [[ position ]];
    float4 color;
};

struct Uniforms
{
    float4x4 modelMatrix;
};

vertex VertexOut basic_vertex(const device VertexIn* vertex_array [[ buffer(0) ]],
                              const device Uniforms&  uniforms    [[ buffer(1) ]],
                              unsigned int vid [[ vertex_id ]])
{
    float4x4 mv_Matrix = uniforms.modelMatrix;
    VertexIn VertexIn = vertex_array[vid];
    VertexOut VertexOut;
    
    VertexOut.position = mv_Matrix * float4(VertexIn.position,1);
    VertexOut.color = VertexIn.color;
    
    return VertexOut;
}

fragment half4 basic_fragment(VertexOut interpolated [[ stage_in ]])
{
    return half4(interpolated.color[0], interpolated.color[1], interpolated.color[2], interpolated.color[3]);
}

