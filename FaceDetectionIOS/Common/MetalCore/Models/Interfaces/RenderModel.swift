//
//  RenderModel.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 16.06.2023.
//

import Foundation
import MetalKit

protocol RenderModel {
    func render(encoder: MTLRenderCommandEncoder, uniform: Uniform)
}
