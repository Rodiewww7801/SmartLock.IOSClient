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

protocol FaceDetectorDelegate: AnyObject { 
    func convertFromMetadataToPreviewRect(rect: CGRect) -> CGRect
    func draw(image: CIImage)
}

protocol FaceDectorDelegateViewModel: AnyObject {
    func perform(action: CameraViewModelAction)
    func getHideBackgroundState() -> Bool
}

class FaceDetector: NSObject {
    weak var modelDelegate: FaceDectorDelegateViewModel?
    weak var presentedDelegate: FaceDetectorDelegate?
    
    var sequenceHandler = VNSequenceRequestHandler()
    var currentFrameBuffer: CVImageBuffer?
    var isCapturingPhoto: Bool = false
    var faceQuality: Float = 0
    
    private var subscriptions = Set<AnyCancellable>()
    private var imageProcessingQueue = DispatchQueue(label: "Image Processing Queue",
                                                     qos: .userInitiated,
                                                     attributes: [],
                                                     autoreleaseFrequency: .workItem)
    
    private func detectFaceRectangles(request: VNRequest, error: Error?) {
        guard let viewDelegate = presentedDelegate else { return }
        
        guard let result = (request.results as? [VNFaceObservation])?.first else {
            modelDelegate?.perform(action: .noFaceDetected)
            return
        }
        
        let convertBoundingBox = viewDelegate.convertFromMetadataToPreviewRect(rect: result.boundingBox)
        let faceObservationModel = FaceGeometryModel(boundingBox: convertBoundingBox, roll: result.roll, pitch: result.pitch, yaw: result.yaw, quality: faceQuality)
        modelDelegate?.perform(action: .faceObservationDetected(faceObservationModel))
    }
    
    private func detectedFaceQualityRequest(request: VNRequest, error: Error?) {
        guard let result = (request.results as? [VNFaceObservation])?.first else {
            modelDelegate?.perform(action: .noFaceDetected)
            return
        }
        
        let faceQuality = result.faceCaptureQuality ?? 0
        self.faceQuality = faceQuality
    }
    
    private func detectedSegmentationRequest(request: VNRequest, error: Error?) {
        guard let model = modelDelegate,
              let currentFrameBuffer = currentFrameBuffer,
              let result = (request.results as? [VNPixelBufferObservation])?.first
        else {
            return
        }
        
        if model.getHideBackgroundState() {
            let originalImage = CIImage(cvImageBuffer: currentFrameBuffer)
            let maskPixelBuffer = result.pixelBuffer
            let outputImage = removeBackgroundFrom(image: originalImage, using: maskPixelBuffer)
            presentedDelegate?.draw(image: outputImage.oriented(.upMirrored))
        } else {
            let originalImage = CIImage(cvImageBuffer: currentFrameBuffer).oriented(.upMirrored)
            presentedDelegate?.draw(image: originalImage)
        }
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
    
    private func captureCurrentImage(from imageBuffer: CVImageBuffer) {
        imageProcessingQueue.async { [weak self] in
            guard let self = self else { return }
            let originalImage = CIImage(cvImageBuffer: imageBuffer)
            var outputImage = originalImage
            
            //remove background
            if self.modelDelegate?.getHideBackgroundState() ?? false {
                let detectSegmentationRequest = VNGeneratePersonSegmentationRequest()
                detectSegmentationRequest.qualityLevel = .accurate
                
                try? self.sequenceHandler.perform([detectSegmentationRequest], on: imageBuffer, orientation: .leftMirrored)
                
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
                    self?.modelDelegate?.perform(action: .savePhoto(savedImage))
                }
            }
        }
    }
}

extension FaceDetector: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        if isCapturingPhoto {
            isCapturingPhoto = false
            captureCurrentImage(from: imageBuffer)
        }
        
        let detectFaceRectanglesRequest = VNDetectFaceRectanglesRequest(completionHandler: detectFaceRectangles)
        detectFaceRectanglesRequest.revision = VNDetectFaceLandmarksRequestRevision3
        
        let detectFaceQualityRequest = VNDetectFaceCaptureQualityRequest(completionHandler: detectedFaceQualityRequest)
        detectFaceQualityRequest.revision = VNDetectFaceCaptureQualityRequestRevision2
        
        let detectSegmentationRequest = VNGeneratePersonSegmentationRequest(completionHandler: detectedSegmentationRequest)
        detectSegmentationRequest.qualityLevel = .balanced
        
        self.currentFrameBuffer = imageBuffer
        do {
            try sequenceHandler.perform([detectFaceRectanglesRequest, detectFaceQualityRequest, detectSegmentationRequest], on: imageBuffer, orientation: .leftMirrored)
            
        } catch {
            fatalError("\(error)")
        }
    }
}
