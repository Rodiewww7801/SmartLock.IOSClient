//
//  CVPixelBuffer + Extension.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 16.06.2023.
//

import MetalKit

extension CVPixelBuffer {
    func texture(withFormat pixelFormat: MTLPixelFormat, planeIndex: Int, addToCache cache: CVMetalTextureCache) -> MTLTexture? {
        let width = CVPixelBufferGetWidthOfPlane(self, planeIndex)
        let height = CVPixelBufferGetHeightOfPlane(self, planeIndex)
        var cvTexture: CVMetalTexture?
        _ = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, cache, self, nil, pixelFormat, width, height, planeIndex, &cvTexture)
        var texture: MTLTexture? = nil
        if let cvTexture = cvTexture {
            texture = CVMetalTextureGetTexture(cvTexture)
        }
        return texture
    }
    
    func texture(withFormat pixelFormat: MTLPixelFormat, addToCache cache: CVMetalTextureCache) -> MTLTexture? {
        let width = CVPixelBufferGetWidth(self)
        let height = CVPixelBufferGetHeight(self)
        var cvTexture: CVMetalTexture?
        _ = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, cache, self, nil, pixelFormat, width, height, 0, &cvTexture)
        var texture: MTLTexture? = nil
        if let cvTexture = cvTexture {
            texture = CVMetalTextureGetTexture(cvTexture)
        }
        return texture
    }
}
