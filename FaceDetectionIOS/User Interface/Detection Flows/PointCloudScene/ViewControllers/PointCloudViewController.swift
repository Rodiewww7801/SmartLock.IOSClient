//
//  PointCloudViewController.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.05.2023.
//

import UIKit
import AVFoundation
import MetalKit
import ARKit

class PointCloudViewController: UIViewController {
    //Metal
    private var metalView: MTKView!
    private var renderer: Renderer!
    
    //AVFoundation
    private var sessionQueue: DispatchQueue
    private var arSessionQueue: DispatchQueue
    private var captureSession: AVCaptureSession
    private var videDeviceDiscoverySession: AVCaptureDevice.DiscoverySession
    private var videoDeviceInput: AVCaptureDeviceInput!
    private var videoDataOutput: AVCaptureVideoDataOutput
    private var depthDataOutput: AVCaptureDepthDataOutput
    private var outputSynchronizer: AVCaptureDataOutputSynchronizer?
    private var outputSynchronizerQueue: DispatchQueue
    
    //ARKit
    private var arSession: ARSession
    
    //helpers
    private var sessionSetupResult: SessionSetupResult
    private var renderingEnabled: Bool = true
    private var pinchGestureObservers: NSHashTable<AnyObject> = .weakObjects()
    private var panGestureObservers: NSHashTable<AnyObject> = .weakObjects()
    private var depthDataDispathQueue = DispatchQueue(label: "depthDataDispathQueue", qos: .default, attributes: [], autoreleaseFrequency: .workItem)
    
    var showSettings: (()->())?
    var onBackTapped: (()->())?
    
    init() {
        self.sessionSetupResult = .success
        self.captureSession = AVCaptureSession()
        self.videoDataOutput = AVCaptureVideoDataOutput()
        self.depthDataOutput = AVCaptureDepthDataOutput()
        self.arSession = ARSession()
        self.sessionQueue = DispatchQueue(label: "session_queue", attributes: [], autoreleaseFrequency: .workItem)
        self.arSessionQueue = DispatchQueue(label: "ar_session_queue", attributes: [], autoreleaseFrequency: .workItem)
        self.outputSynchronizerQueue = DispatchQueue(label: "video_data_queue_synchronized", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
        self.videDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera], mediaType: .video, position: .front)
        super.init(nibName: nil, bundle: nil)
        self.arSession.delegate = self
        print("[DepthDataViewController]: init")
    }
    
    deinit {
        print("[DepthDataViewController]: deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            self.onBackTapped?()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSettingsNavigationItem()
        
        //        authorizationStatus { [weak self] in
        //            self?.configureSession()
        //        }
        //
        addMetalView()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
        self.metalView.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureHandler))
        self.metalView.addGestureRecognizer(pinchGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        sessionQueue.async { [weak self] in
        //            self?.startSession()
        //        }
        
        arSessionQueue.async { [weak self] in
            self?.startARSession()
        }
    }
    
    private func addMetalView() {
        let device = MTLCreateSystemDefaultDevice()
        self.metalView = MTKView(frame: .zero, device: device)
        self.renderer = Renderer(mtkView: metalView)
        self.subscribeOnPanGesture(self.renderer.camera)
        self.subscribeOnPinchGesture(self.renderer.camera)
        self.view.addSubview(metalView)
        metalView.translatesAutoresizingMaskIntoConstraints = false
        metalView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        metalView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        metalView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        metalView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func addSettingsNavigationItem() {
        let settingsNavigationItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(onSettingsTapped))
        self.navigationItem.rightBarButtonItem = settingsNavigationItem
    }
    
    @objc private func onSettingsTapped() {
        self.showSettings?()
    }
}


//MARK: - Configure Capture Session

extension PointCloudViewController {
    
    private func authorizationStatus(_ completion: (()->())?) {
        self.sessionSetupResult = .success
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if !granted {
                    self.sessionSetupResult = .notAuthorized
                }
                self.sessionQueue.resume()
            }
            break
        default:
            self.sessionSetupResult = .notAuthorized
            print("[DepthDataViewController]: authorizationStatus not accepted")
        }
        
        if self.sessionSetupResult == .success {
            sessionQueue.async {
                completion?()
            }
        }
    }
    
    private func configureSession() {
        let defaultVideoDevice: AVCaptureDevice? = videDeviceDiscoverySession.devices.first
        guard let defaultVideoDevice = defaultVideoDevice else  {
            print("[DepthDataViewController]: Could not find any video device")
            self.sessionSetupResult = .configurationFailed
            return
        }
        
        do {
            videoDeviceInput = try AVCaptureDeviceInput(device: defaultVideoDevice)
        } catch {
            print("[DepthDataViewController]: \(error)")
            self.sessionSetupResult = .configurationFailed
            return
        }
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .vga640x480
        captureSession.addInput(videoDeviceInput)
        captureSession.addOutput(videoDataOutput)
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        
        captureSession.addOutput(depthDataOutput)
        depthDataOutput.isFilteringEnabled = false
        if let connection = depthDataOutput.connection(with: .depthData) {
            connection.isEnabled = true
        } else {
            print("[DepthDataViewController] No AVCaptureConnection")
            self.sessionSetupResult = .configurationFailed
            return
        }
        
        let depthFormats = defaultVideoDevice.activeFormat.supportedDepthDataFormats
        let filtered = depthFormats.filter({
            CMFormatDescriptionGetMediaSubType($0.formatDescription) == kCVPixelFormatType_DepthFloat16 // todo: try 32
        })
        
        let selectedFormat = filtered.max(by: { first, second in
            CMVideoFormatDescriptionGetDimensions(first.formatDescription).width < CMVideoFormatDescriptionGetDimensions(second.formatDescription).width
        })
        
        do {
            try defaultVideoDevice.lockForConfiguration()
            defaultVideoDevice.activeDepthDataFormat = selectedFormat
            defaultVideoDevice.unlockForConfiguration()
        } catch {
            print("[DepthDataViewController]: Could not lock device for configuration:")
            self.sessionSetupResult = .configurationFailed
            return
        }
        
        outputSynchronizer = AVCaptureDataOutputSynchronizer(dataOutputs: [videoDataOutput, depthDataOutput])
        outputSynchronizer?.setDelegate(self, queue: outputSynchronizerQueue)
        captureSession.commitConfiguration()
    }
    
    private func startSession() {
        switch self.sessionSetupResult {
        case .success:
            self.outputSynchronizerQueue.async { [weak self] in
                self?.renderingEnabled = true
            }
            
            self.captureSession.startRunning()
        case .notAuthorized:
            let alert = FDAlert()
            alert.createWith(title: "Alert message when the user has denied access to the camera",
                             message: "Application doesn't have permission to use the camera, please change privacy settings")
            alert.addAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(title: "Settings", style: .default, handler: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                          options: [:],
                                          completionHandler: nil)
            })
            alert.present(on: self)
        case .configurationFailed:
            //todo add unavailable label
            break
        }
    }
    
    private func startARSession() {
        arSession.run(ARFaceTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
    }
}

// MARK: - Gestures

extension PointCloudViewController {
    private func subscribeOnPinchGesture(_ gestureObserver: GestureController?) {
        guard let gestureObserver = gestureObserver else { return }
        if !pinchGestureObservers.contains(gestureObserver) {
            pinchGestureObservers.add(gestureObserver)
        }
    }
    
    private func subscribeOnPanGesture(_ gestureObserver: GestureController?) {
        guard let gestureObserver = gestureObserver else { return }
        if !panGestureObservers.contains(gestureObserver) {
            panGestureObservers.add(gestureObserver)
        }
    }
    
    @objc private func panGestureHandler(gesture: UIPanGestureRecognizer) {
        self.panGestureObservers.allObjects.forEach { object in
            (object as? GestureController)?.panGestureHandler(gesture: gesture)
        }
    }
    
    @objc private func pinchGestureHandler(gesture: UIPinchGestureRecognizer) {
        self.pinchGestureObservers.allObjects.forEach { object in
            (object as? GestureController)?.pinchGestureHandler(gesture: gesture)
        }
    }
}

// MARK: - AVCaptureDataOutputSynchronizerDelegate

extension PointCloudViewController: AVCaptureDataOutputSynchronizerDelegate {
    func dataOutputSynchronizer(_ synchronizer: AVCaptureDataOutputSynchronizer, didOutput synchronizedDataCollection: AVCaptureSynchronizedDataCollection) {
        if !renderingEnabled {
            return
        }
        
        guard renderingEnabled,
              let syncedDepthData: AVCaptureSynchronizedDepthData =
                synchronizedDataCollection.synchronizedData(for: depthDataOutput) as? AVCaptureSynchronizedDepthData,
              let syncedVideoData: AVCaptureSynchronizedSampleBufferData =
                synchronizedDataCollection.synchronizedData(for: videoDataOutput) as? AVCaptureSynchronizedSampleBufferData else {
            return
        }
        
        if syncedDepthData.depthDataWasDropped || syncedVideoData.sampleBufferWasDropped {
            return
        }
        
        let depthData = syncedDepthData.depthData
        let sampleBuffer = syncedVideoData.sampleBuffer
        guard let videoPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        //self.renderer?.setDepthFrame(depth: depthData, withTexture: videoPixelBuffer)
    }
}

// MARK: - ARSessionDelegate

extension PointCloudViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let pixelBuffer = frame.capturedImage
        if CVPixelBufferGetPlaneCount(pixelBuffer) < 2 {
            return
        }
        
        var transform = Transform()
        transform.position = [0,0,-5]
        transform.rotation = [0, Float(180).degreesToRadians, 0]
        transform.scale = 1000
        let conversionMatrix = float4x4(
            float4(-1, 0, 0, 0),
            float4(0, 1, 0, 0),
            float4(0, 0, -1, 0),
            float4(0, 0, 0, 1)
        )
        
        if let faceAnchor = frame.anchors.first as? ARFaceAnchor {
            let uniform =
            renderer.camera!.projectionMatrix *
            renderer.camera!.viewMatrix *
            transform.transformMatrix *
            frame.camera.viewMatrix(for: .portrait) *
            faceAnchor.transform
            
            self.renderer?.setFaceMeshModel(faceAnchor.geometry.vertices, uniform)
        }
        
        if let depthData = frame.capturedDepthData {
            readDepth(depthData, capturedImage: frame.capturedImage)
            self.renderer?.setDepthFrame(depth: depthData, withTexture: frame.capturedImage)
        }
    }
    
    private func readDepth(_ depthData: AVDepthData, capturedImage: CVPixelBuffer) {
        depthDataDispathQueue.async { [depthData, capturedImage] in
            // face detect on depth
            let detectorOptions: [String: Any] = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: detectorOptions)
            let features = faceDetector?.features(in: CIImage(cvPixelBuffer: capturedImage))
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
                return
            }
            
            var depthDataMap = depthData.depthDataMap
            CVPixelBufferLockBaseAddress(depthDataMap, .readOnly)
            
            let scaleX = CGFloat(CVPixelBufferGetWidth(depthDataMap)) / CGFloat(CVPixelBufferGetWidth(capturedImage))
            let scaleY = CGFloat(CVPixelBufferGetHeight(depthDataMap)) / CGFloat(CVPixelBufferGetHeight(capturedImage))
            let depthRect = CGRect(x: faceBounds.minX * scaleX, y: faceBounds.minY * scaleY, width: faceBounds.width * scaleX, height: faceBounds.height * scaleY)
            var cidepthImage = CIImage(cvPixelBuffer: depthDataMap)
            let ciColorImage = CIImage(cvImageBuffer: capturedImage)
            
            mouthPosition = CGPoint(x: mouthPosition.x * scaleX, y:  mouthPosition.y * scaleY)
            leftEyePosition = CGPoint(x: leftEyePosition.x * scaleX, y:  leftEyePosition.y * scaleY)
            rightEyePosition = CGPoint(x: rightEyePosition.x * scaleX, y:  rightEyePosition.y * scaleY)
            
            //let scaleTransform = CGAffineTransform(scaleX: 200 / depthRect.width, y: 250 / depthRect.height)
            let cropedImage = cidepthImage.cropped(to: depthRect)
            let cropedImage2  = ciColorImage.cropped(to: faceBounds)
            
            let baseAddress = CVPixelBufferGetBaseAddress(depthDataMap)!
            let bytesPerRow = CVPixelBufferGetBytesPerRow(depthDataMap)
            
            let rowData = baseAddress + Int(cidepthImage.extent.maxY - (leftEyePosition.y + (rightEyePosition.y - leftEyePosition.y) / 2)) * bytesPerRow
            let centerValue = rowData.assumingMemoryBound(to: Float32.self)[Int(leftEyePosition.x + (mouthPosition.x - leftEyePosition.x) / 2)] * 100.0
            
            let rowDataMouth = baseAddress + Int(cidepthImage.extent.maxY - mouthPosition.y) * bytesPerRow
            let mouthValue = rowDataMouth.assumingMemoryBound(to: Float32.self)[Int(mouthPosition.x)] * 100.0
            
            let rowDataLeftEye = baseAddress + Int(cidepthImage.extent.maxY - leftEyePosition.y) * bytesPerRow
            let leftEyeValue = rowDataLeftEye.assumingMemoryBound(to: Float32.self)[Int(leftEyePosition.x)] * 100.0
            
            let rowDataRightEye = baseAddress + Int(cidepthImage.extent.maxY - rightEyePosition.y) * bytesPerRow
            let rightEyeValue = rowDataRightEye.assumingMemoryBound(to: Float32.self)[Int(rightEyePosition.x)] * 100.0
            
            print("center: \(centerValue )")
            print("mouth: \(mouthValue)")
            print("left: \(leftEyeValue)")
            print("right: \(rightEyeValue)")
        
            
            var depthValues = [centerValue, mouthValue, leftEyeValue, rightEyeValue]
            
            let normalizedValues = depthValues.map { (value) -> Float in
                let normalizedValue: Float = Float(value) / Float(centerValue)
                let scaledValue = normalizedValue
                if round(scaledValue * 100) / 100  > 1 {
                    return scaledValue
                } else {
                    return 0
                }
                
            }
            
            let isReal: Bool = !((centerValue > mouthValue) && (centerValue > leftEyeValue) && centerValue > rightEyeValue)
            let sumValues = normalizedValues.reduce(0, +)
            print("isRealFace: \(sumValues) \(sumValues >= 3)")
            print("\n\n")
            
            CVPixelBufferUnlockBaseAddress(depthDataMap, .readOnly)
        }
    }
}








