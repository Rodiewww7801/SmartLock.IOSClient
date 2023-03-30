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
    private var currentCIImage: CIImage?  {
        didSet {
        metalView?.draw()
      }
    }
    
    var faceDetector: FaceDetector?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var session: AVCaptureSession = AVCaptureSession()
    
    let videoOutputQueue = DispatchQueue(label: "Video Output Queue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    init(with viewModel: MainCameraViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.faceDetector = viewModel.faceDetector
        self.faceDetector?.presentedDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMetal()
        configureSession()
        DispatchQueue.global().async { [weak self] in
            self?.session.startRunning()
        }
    }
    
    private func configureMetal() {
        guard let metalDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Could not instantiate required metal properties")
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
        metalView?.layer.contentsGravity = .resizeAspect
        if let metalView = metalView {
            view.layer.insertSublayer(metalView.layer, at: 0)
        }
        
        ciContext = CIContext(mtlDevice: metalDevice)
    }
    
    private func configureSession() {
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            fatalError("No front video camera available")
        }
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            session.addInput(cameraInput)
        } catch {
            fatalError("\(error)")
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(faceDetector, queue: videoOutputQueue)
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA]
        session.addOutput(videoOutput)
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = .resizeAspect
        previewLayer?.frame = self.view.bounds
        
        if let previewLayer = previewLayer, !isUsingMetal {
            view.layer.insertSublayer(previewLayer, at: 0)
        }
    }
}

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

extension CameraCaptureVC: FaceDetectorDelegate {
    func draw(image: CIImage) {
        currentCIImage = image
    }
    
    func convertFromMetadataToPreviewRect(rect: CGRect) -> CGRect {
        guard let previewLayer = previewLayer else { return CGRect.zero }
        return previewLayer.layerRectConverted(fromMetadataOutputRect: rect)
    }
}

