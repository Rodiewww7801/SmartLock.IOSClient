//
//  ShaderCommon.h
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 16.06.2023.
//

#ifndef ShaderCommon_h
#define ShaderCommon_h

#import <simd/simd.h>

typedef struct {
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 projectionMatrix;
} Uniform;

typedef struct {
    matrix_float3x3 cameraIntrinsics;
} CameraCalibrationData;

typedef struct  {
    uint pointToCloud;
    uint faceMesh;
} ModelType;

typedef enum {
    kBufferIndexUniform = 2,
    kBufferIndexCameraCalibrationData = 3,
    kBufferIndexModelType = 4,
    kBufferIndexFaceMeshVertices = 5
} BufferIndices;

typedef enum {
    kTexutreIndexColor = 0,
    kTextureIndexY = 1,
    kTextureIndexCbCr = 2,
    kTextureIndexDepth = 3
} TextureIndices;


#endif /* ShaderCommon_h */
