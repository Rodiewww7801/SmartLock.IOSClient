//
//  FaceDetector.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 28.03.2023.
//

import Foundation
import AVFoundation
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins
import Combine
import UIKit

protocol FaceDetectorPresenterDelegate: AnyObject { 
    func convertFromMetadataToPreviewRect(rect: CGRect) -> CGRect
    //func draw(image: CIImage)
}

protocol FaceDetectorViewModelDelegate: AnyObject {
    func publishNoFaceObserved()
    func publishFaceObservation(_ faceGeometryModel: FaceGeometryModel)
    func publishSavePhotoObservation(_ image: UIImage)
    func getHideBackgroundState() -> Bool
}

class FaceDetector: NSObject {
    weak var viewModelDelegate: FaceDetectorViewModelDelegate?
    weak var presentationDelegate: FaceDetectorPresenterDelegate?
    
    private var sequenceHandler = VNSequenceRequestHandler()
    private var imageCaptureQueue = DispatchQueue(label: "image_capture_queue",
                                                     qos: .userInitiated,
                                                     attributes: [],
                                                     autoreleaseFrequency: .workItem)
    private var imageProcessingQueue = DispatchQueue(label: "image_processing_queue",
                                                     qos: .userInitiated,
                                                     attributes: [],
                                                     autoreleaseFrequency: .workItem)
    private var currentFrameBuffer: CVImageBuffer?
    private var faceObservationModel: FaceGeometryModel =  FaceGeometryModel()
    var isCapturingPhoto: Bool = false
    
    func processData(captureData: CVImageBuffer, depthData: AVDepthData) {
        imageProcessingQueue.async { [weak self] in
            self?.performDetectionRequests(captureData: captureData)
            self?.processFaceAuthenticity(depthData, imageBuffer: captureData)
        }
    }
    
    func captureCurrentImage() {
        imageCaptureQueue.async { [weak self] in
            guard let self = self, let currentFrameBuffer = self.currentFrameBuffer else { return }
            let originalImage = CIImage(cvImageBuffer: currentFrameBuffer)
            var outputImage = originalImage
            
            //remove background
            if self.viewModelDelegate?.getHideBackgroundState() ?? false {
                let detectSegmentationRequest = VNGeneratePersonSegmentationRequest()
                detectSegmentationRequest.qualityLevel = .accurate
                
                try? self.sequenceHandler.perform([detectSegmentationRequest], on: currentFrameBuffer, orientation: .leftMirrored)
                
                if let maskPixelBuffer = detectSegmentationRequest.results?.first?.pixelBuffer {
                    outputImage = self.removeBackgroundFrom(image: originalImage, using: maskPixelBuffer)
                }
            }
            
            let coreImageWidth = outputImage.extent.width
            let coreImageHeight = outputImage.extent.height
            let desiredImageHeight = coreImageWidth * 4/3
            let yOrigin = (coreImageHeight - desiredImageHeight) / 2
            let photoRect = CGRect(x: 0, y: yOrigin, width: coreImageWidth, height: desiredImageHeight)
            
            let context = CIContext()
            if let cgImage = context.createCGImage(outputImage, from: photoRect) {
                let savedImage = UIImage(cgImage: cgImage, scale: 1, orientation: .upMirrored)
                
                DispatchQueue.main.async { [weak self] in
                    self?.viewModelDelegate?.publishSavePhotoObservation(savedImage)
                }
            }
        }
    }
    
    private func publishFaceObserved() {
        viewModelDelegate?.publishFaceObservation(faceObservationModel)
    }
    
    private func publishNoFaceObserved() {
        viewModelDelegate?.publishNoFaceObserved()
    }
    
    private func performDetectionRequests(captureData: CVImageBuffer) {
        let detectFaceRectanglesRequest = VNDetectFaceRectanglesRequest(completionHandler: detectedFaceRectanglesRequest)
        detectFaceRectanglesRequest.revision = VNDetectFaceLandmarksRequestRevision3
        
        let detectFaceQualityRequest = VNDetectFaceCaptureQualityRequest(completionHandler: detectedFaceQualityRequest)
        detectFaceQualityRequest.revision = VNDetectFaceCaptureQualityRequestRevision2
        
        self.currentFrameBuffer = captureData
        try? sequenceHandler.perform([detectFaceRectanglesRequest,
                                      detectFaceQualityRequest],
                                     on: captureData,
                                     orientation: .downMirrored)
    }
    
    private func detectedFaceRectanglesRequest(request: VNRequest, error: Error?) {
        guard let result = (request.results as? [VNFaceObservation])?.first else {
            self.publishNoFaceObserved()
            return
        }
        
        let convertBoundingBox = presentationDelegate?.convertFromMetadataToPreviewRect(rect: result.boundingBox) ?? .zero
        self.faceObservationModel.boundingBox = convertBoundingBox
        self.faceObservationModel.pitch = result.pitch ?? 0
        self.faceObservationModel.yaw = result.yaw ?? 0
        self.faceObservationModel.roll = result.roll ?? 0
        
        self.publishFaceObserved()
    }
    
    private func detectedFaceQualityRequest(request: VNRequest, error: Error?) {
        guard let result = (request.results as? [VNFaceObservation])?.first else {
            viewModelDelegate?.publishNoFaceObserved()
            return
        }
        
        let faceQuality = result.faceCaptureQuality ?? 0
        self.faceObservationModel.quality = faceQuality
    }
    
    private func removeBackgroundFrom(image: CIImage, using maskPixelBuffer: CVPixelBuffer) -> CIImage {
        var maskImage = CIImage(cvPixelBuffer: maskPixelBuffer)

        let originalImage = image.oriented(.right)

        let scaleX = originalImage.extent.width / maskImage.extent.width
        let scaleY = originalImage.extent.height / maskImage.extent.height
        maskImage = maskImage.transformed(by: .init(scaleX: scaleX, y: scaleY)).oriented(.upMirrored)

        let backgroundImage = CIImage(color: .white).clampedToExtent().cropped(to: originalImage.extent)

        let blendFilter = CIFilter.blendWithRedMask()
        blendFilter.inputImage = originalImage
        blendFilter.backgroundImage = backgroundImage
        blendFilter.maskImage = maskImage

        if let outputImage = blendFilter.outputImage?.oriented(.left) {
          return outputImage
        }

        return originalImage
    }
    
    private func processFaceAuthenticity(_ depthData: AVDepthData, imageBuffer: CVImageBuffer) {
        guard let face = getFaceFeatures(imageBuffer) else { return }
        let depthDataMap = depthData.depthDataMap
        
        CVPixelBufferLockBaseAddress(depthDataMap, .readOnly)
        let cidepthImage = CIImage(cvPixelBuffer: depthDataMap)
        
        let baseAddress = CVPixelBufferGetBaseAddress(depthDataMap)!
        let bytesPerRow = CVPixelBufferGetBytesPerRow(depthDataMap)
        
        let rowDataCenter = baseAddress + Int(cidepthImage.extent.maxY - face.centerPosition.y) * bytesPerRow
        let centerValue = rowDataCenter.assumingMemoryBound(to: Float16.self)[Int(face.centerPosition.x)] * 100.0
        
        let rowDataMouth = baseAddress + Int(cidepthImage.extent.maxY - face.mouthPosition.y) * bytesPerRow
        let mouthValue = rowDataMouth.assumingMemoryBound(to: Float16.self)[Int(face.mouthPosition.x)] * 100.0
        
        let rowDataLeftEye = baseAddress + Int(cidepthImage.extent.maxY - face.leftEyePosition.y) * bytesPerRow
        let leftEyeValue = rowDataLeftEye.assumingMemoryBound(to: Float16.self)[Int(face.leftEyePosition.x)] * 100.0
        
        let rowDataRightEye = baseAddress + Int(cidepthImage.extent.maxY - face.rightEyePosition.y) * bytesPerRow
        let rightEyeValue = rowDataRightEye.assumingMemoryBound(to: Float16.self)[Int(face.rightEyePosition.x)] * 100.0
        
        let isReal: Bool = ((centerValue < mouthValue) && (centerValue < leftEyeValue) && centerValue < rightEyeValue)
        CVPixelBufferUnlockBaseAddress(depthDataMap, .readOnly)
        
        let faceAuthenticity: FaceAuthenticity = isReal ? .realFace : .fakeFace
        self.faceObservationModel.faceAuthenticity = faceAuthenticity
    }
    
    private func getFaceFeatures(_ imageBuffer: CVImageBuffer) -> FaceFeaturePosition? {
        let detectorOptions: [String: Any] = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: detectorOptions)
        let features = faceDetector?.features(in: CIImage(cvImageBuffer: imageBuffer))
    
        var faceBounds: CGRect = .zero
        var mouthPosition = CGPoint()
        var leftEyePosition = CGPoint()
        var rightEyePosition = CGPoint()
        
        features?.forEach { feature in
            if let faceFeature = feature as? CIFaceFeature {
                faceBounds = faceFeature.bounds
                mouthPosition = faceFeature.mouthPosition
                leftEyePosition = faceFeature.leftEyePosition
                rightEyePosition = faceFeature.rightEyePosition
            }
        }
    
        if faceBounds == .zero {
            return nil
        }
        
        let centerPositionY = leftEyePosition.y + (rightEyePosition.y - leftEyePosition.y) / 2
        let centerPositionX = leftEyePosition.x + (mouthPosition.x - leftEyePosition.x) / 2
        let centerPosition = CGPoint(x: centerPositionX, y: centerPositionY)
        
        return FaceFeaturePosition(faceBounds: faceBounds,
                                   leftEyePosition: leftEyePosition,
                                   rightEyePosition: rightEyePosition,
                                   mouthPosition: mouthPosition,
                                   centerPosition: centerPosition)
    }
}
