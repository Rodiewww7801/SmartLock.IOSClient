/*
 Copyright © 2021 Apple Inc.

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Abstract:
Metal shaders used for point-cloud view
*/

#include <metal_stdlib>
using namespace metal;
#import "ShaderCommon.h"

typedef struct
{
    float4 clipSpacePosition [[position]];
    float2 coor;
    float pSize [[point_size]];
    float depth;
    float4 color;
} ParticleVertexInOut;

float4 convertYCbCrToRGBA(float4 colorYtexture, float4 colorCbCrtexture);

vertex ParticleVertexInOut
vertexShaderPoints(uint vertexID [[ vertex_id ]],
                   texture2d<float, access::read> depthTexture [[ texture(kTextureIndexDepth) ]],
                   constant ModelType &modelType [[ buffer(kBufferIndexModelType)]],
                   constant Uniform &uniform [[ buffer(kBufferIndexUniform) ]],
                   constant CameraCalibrationData& cameraCalibrationData [[ buffer(kBufferIndexCameraCalibrationData) ]],
                   const device vector_float3 *facePoint [[buffer(kBufferIndexFaceMeshVertices)]])
{
    ParticleVertexInOut out;
    if (modelType.pointToCloud == 1) {
        uint2 pos;
        pos.y = vertexID / depthTexture.get_width();
        pos.x = vertexID % depthTexture.get_width();
        
        // depthDataType is kCVPixelFormatType_DepthFloat32
        float depth = depthTexture.read(pos).x * 1000.0f;
        
        matrix_float3x3 cameraIntrinsics = cameraCalibrationData.cameraIntrinsics;
        
        float xrw = (pos.x - cameraIntrinsics[2][0]) * depth / cameraIntrinsics[0][0];
        float yrw = (pos.y - cameraIntrinsics[2][1]) * depth / cameraIntrinsics[1][1];
        
        float4 xyzw = { xrw, yrw, depth, 1.f };
        out.clipSpacePosition = uniform.projectionMatrix * uniform.viewMatrix * uniform.modelMatrix * xyzw;
        out.coor = { pos.x / (depthTexture.get_width() - 1.0f), pos.y / (depthTexture.get_height() - 1.0f) };
        out.depth = depth;
        out.pSize = 3.0f;
    }
    
    if (modelType.faceMesh == 1) {
        float4x4 modelViewProjectMatrix =  uniform.modelMatrix;
        out.clipSpacePosition = modelViewProjectMatrix * float4(facePoint[vertexID], 1.0);
        out.pSize = 5.0;
    }

    return out;
}

fragment float4 fragmentShaderPoints(ParticleVertexInOut in [[stage_in]],
                                     texture2d<float> colorYtexture [[texture(kTextureIndexY)]],
                                     texture2d<float> colorCbCrtexture [[texture(kTextureIndexCbCr)]],
                                     constant ModelType &modelType [[buffer(kBufferIndexModelType)]])
{
    if (modelType.faceMesh == 1) {
        return float4(0,0,1,1);
    }

    if (in.depth >= 1.0) {
        constexpr sampler textureSampler (mag_filter::linear, min_filter::linear);
        const float4 colorSampleY = colorYtexture.sample (textureSampler, in.coor);
        const float4 colorSampleCbCr = colorCbCrtexture.sample (textureSampler, in.coor);
        
        return convertYCbCrToRGBA(colorSampleY, colorSampleCbCr);
    }
    discard_fragment();
    return 0;
}

// MARK: - Helper func

// Convert the Y and CbCr textures into a single RGBA texture.
float4 convertYCbCrToRGBA(float4 colorYtexture,
                          float4 colorCbCrtexture)
{
    const float4x4 ycbcrToRGBTransform = float4x4(
        float4(+1.0000f, +1.0000f, +1.0000f, +0.0000f),
        float4(+0.0000f, -0.3441f, +1.7720f, +0.0000f),
        float4(+1.4020f, -0.7141f, +0.0000f, +0.0000f),
        float4(-0.7010f, +0.5291f, -0.8860f, +1.0000f)
    );
    
    // Sample Y and CbCr textures to get the YCbCr color at the given texture
    // coordinate.
    float4 ycbcr = float4(colorYtexture.r, colorCbCrtexture.rg, 1.0f);
    
    // Return the converted RGB color.
    float4 rgbColor = ycbcrToRGBTransform * ycbcr;

    return rgbColor;
}


struct FaceInputVertexIO {
    float4 position [[position]];
    float  point_size [[point_size]];
};

vertex FaceInputVertexIO facePointVertex(const device vector_float3 *facePoint [[buffer(kBufferIndexFaceMeshVertices)]],
                                         constant Uniform &faceMeshUniforms [[buffer(kBufferIndexUniform)]],
                                         ushort vid [[vertex_id]]) {
    float4x4 modelViewProjectMatrix = faceMeshUniforms.projectionMatrix * faceMeshUniforms.viewMatrix * faceMeshUniforms.modelMatrix;
    FaceInputVertexIO outputVertices;
    outputVertices.position = modelViewProjectMatrix * float4(facePoint[vid], 1.0);
    outputVertices.point_size = 2.5;
    return outputVertices;
}

fragment float4 facePointFragment(FaceInputVertexIO fragmentInput [[stage_in]]) {
    return float4(0.0, 0.0, 1.0, 1.0);
}
