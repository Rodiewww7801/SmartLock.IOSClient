//
//  CameraCaptureVC.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 29.03.2023.
//

import UIKit
import AVFoundation
import MetalKit

class CameraCaptureVC: UIViewController {
    private var isUsingMetal: Bool = false
    private var metalCommandQueue: MTLCommandQueue?
    private var metalView: MTKView?
    private var ciContext: CIContext?
    private var alert: FDAlert = FDAlert()
    private var currentCIImage: CIImage?
    
    private var faceDetector: FaceDetector?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var captureSession: AVCaptureSession = AVCaptureSession()
    private var captureDataOutput: AVCaptureVideoDataOutput!
    private var depthDataOutput: AVCaptureDepthDataOutput!
    private var outputSynchronizer: AVCaptureDataOutputSynchronizer?
    
    private let outputSynchronizerQueue = DispatchQueue(label: "video_data_queue_synchronized", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    private let sessionQueue = DispatchQueue(label: "session_queue", attributes: [], autoreleaseFrequency: .workItem)
    
    var showDetectionPermission: (()->Void)?
    
    init(with viewModel: DetectionSceneViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.faceDetector = viewModel.faceDetector
        self.faceDetector?.presentationDelegate = self
        print("[CameraCaptureVC]: init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("[CameraCaptureVC]: deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configureMetal()
        configureSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            checkCameraPermission {  [weak self] in
                self?.sessionQueue.async {
                self?.captureSession.startRunning()
            }
        }
    }
    
    private func checkCameraPermission(_ completion: @escaping ()->Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            print("[CameraCaptureVC] Camera access authorized")
            completion()
        default:
            self.showDetectionPermission?()
            print("[CameraCaptureVC] Camera not authorized")
        }
    }
    
    private func configureMetal() {
        guard let metalDevice = MTLCreateSystemDefaultDevice() else {
            FDAlert()
                .createWith(title: "Error", message: "Could not instantiate required metal properties MTLCreateSystemDefaultDevice")
                .addAction(title: "Close", style: .destructive, handler: {
                    
                }).present(on: self)
            return
        }
        
        isUsingMetal = true
        metalCommandQueue = metalDevice.makeCommandQueue()
        
        metalView = MTKView()
        metalView?.device = metalDevice
        metalView?.isPaused = true
        metalView?.enableSetNeedsDisplay = false
        metalView?.delegate = self
        metalView?.framebufferOnly = false
        metalView?.frame = self.view.bounds
        metalView?.layer.contentsGravity = .resizeAspectFill
        if let metalView = metalView {
            view.layer.insertSublayer(metalView.layer, at: 0)
        }
        
        ciContext = CIContext(mtlDevice: metalDevice)
    }

    private func configureSession() {
        guard let defaultCaptureDevice: AVCaptureDevice = AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .front) else {
            return
        }
        
        var cameraInput: AVCaptureDeviceInput?
        do {
            cameraInput = try AVCaptureDeviceInput(device: defaultCaptureDevice)
        } catch {
            print("[CameraCaptureVC]: error to create AVCaptureDeviceInput \(error)")
        }
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .vga640x480
        if let cameraInput = cameraInput {
            captureSession.addInput(cameraInput)
        }
        captureDataOutput = AVCaptureVideoDataOutput()
        captureDataOutput.alwaysDiscardsLateVideoFrames = true
        captureDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        
        captureSession.addOutput(captureDataOutput)
        depthDataOutput = AVCaptureDepthDataOutput()
        captureSession.addOutput(depthDataOutput)
        depthDataOutput.isFilteringEnabled = false
        
        if let connection = depthDataOutput.connection(with: .depthData) {
            connection.isEnabled = true
        } else {
            print("[CameraCaptureVC] No AVCaptureConnection")
            return
        }
        
        let depthFormats = defaultCaptureDevice.activeFormat.supportedDepthDataFormats
        let filtered = depthFormats.filter({
            CMFormatDescriptionGetMediaSubType($0.formatDescription) == kCVPixelFormatType_DepthFloat16
        })
        
        let selectedFormat = filtered.max(by: { first, second in
            CMVideoFormatDescriptionGetDimensions(first.formatDescription).width < CMVideoFormatDescriptionGetDimensions(second.formatDescription).width
        })
        
        do {
            try defaultCaptureDevice.lockForConfiguration()
            defaultCaptureDevice.activeDepthDataFormat = selectedFormat
            defaultCaptureDevice.unlockForConfiguration()
        } catch {
            print("[CameraCaptureVC]: Could not lock device for configuration \(error)")
        }
        
        outputSynchronizer = AVCaptureDataOutputSynchronizer(dataOutputs: [captureDataOutput, depthDataOutput])
        outputSynchronizer?.setDelegate(self, queue: outputSynchronizerQueue)
        
        captureSession.commitConfiguration()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = self.view.bounds
        
        if let previewLayer = previewLayer {
            view.layer.insertSublayer(previewLayer, at: 0)
        }
    }
}

// MARK: - AVCaptureDataOutputSynchronizerDelegate

extension CameraCaptureVC: AVCaptureDataOutputSynchronizerDelegate {
    func dataOutputSynchronizer(_ synchronizer: AVCaptureDataOutputSynchronizer, didOutput synchronizedDataCollection: AVCaptureSynchronizedDataCollection) {
        guard let syncedDepthData: AVCaptureSynchronizedDepthData = synchronizedDataCollection.synchronizedData(for: depthDataOutput) as? AVCaptureSynchronizedDepthData,
        let syncedVideoData: AVCaptureSynchronizedSampleBufferData = synchronizedDataCollection.synchronizedData(for: captureDataOutput) as? AVCaptureSynchronizedSampleBufferData else {
            return
        }
        
        if syncedDepthData.depthDataWasDropped || syncedVideoData.sampleBufferWasDropped {
            return
        }
        
        let depthData = syncedDepthData.depthData
        let sampleBuffer = syncedVideoData.sampleBuffer
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        self.faceDetector?.processData(captureData: pixelBuffer, depthData: depthData)
    }
}

// MARK: - MTKViewDelegate

extension CameraCaptureVC: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard let metalView = metalView,
              let metalCommandQueue = metalCommandQueue,
              let commandBuffer = metalCommandQueue.makeCommandBuffer(),
              let ciImage = currentCIImage,
              let currentDrawable = view.currentDrawable
        else {
            return
        }
        
        let drawSize = metalView.drawableSize
        let scaleX = drawSize.height / ciImage.extent.height
        let newImage = ciImage.transformed(by: .init(scaleX: scaleX, y: scaleX))
        let originY = (newImage.extent.width - drawSize.width) / 2
        
        ciContext?.render(newImage,
                          to: currentDrawable.texture,
                          commandBuffer: commandBuffer,
                          bounds: CGRect(x: originY, y: 0, width: newImage.extent.width, height: newImage.extent.height),
                          colorSpace: CGColorSpaceCreateDeviceRGB())
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
}

// MARK: - FaceDetectorDelegate

extension CameraCaptureVC: FaceDetectorPresenterDelegate {    
    func draw(image: CIImage) {
        currentCIImage = image
        metalView?.draw()
    }
    
    func convertFromMetadataToPreviewRect(rect: CGRect) -> CGRect {
        guard let previewLayer = previewLayer else { return CGRect.zero }
        return previewLayer.layerRectConverted(fromMetadataOutputRect: rect)
    }
    
    func convertFromMetadataToPreviewRect(point: CGPoint, to rect: CGRect) -> CGPoint? {
        guard let previewLayer = previewLayer else { return nil }
        let point = CGPoint(x: point.x * rect.width + rect.origin.x,
                            y: point.y * rect.height + rect.origin.y)
        return previewLayer.layerPointConverted(fromCaptureDevicePoint: point)
    }
}
