//
//  UIImage + Extension.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 02.10.2023.
//

import UIKit
import Foundation

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpegCompress(_ jpegQuality: JPEGQuality) -> UIImage? {
        let compressedData = jpegData(compressionQuality: jpegQuality.rawValue)
        var compressedImage: UIImage? = nil
        if let compressedData = compressedData {
            compressedImage = UIImage(data: compressedData)
        }
        return compressedImage
    }
}
