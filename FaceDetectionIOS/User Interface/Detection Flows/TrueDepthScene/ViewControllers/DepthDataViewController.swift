//
//  DepthDataViewController.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.05.2023.
//

import UIKit
import AVFoundation
import MetalKit

class DepthDataViewController: UIViewController {
    //Metal
    private var metalView: MTKView!
    private var renderer: Renderer!
    
    //AVFoundation
    private var sessionQueue: DispatchQueue
    private var captureSession: AVCaptureSession
    private var videDeviceDiscoverySession: AVCaptureDevice.DiscoverySession
    private var videoDeviceInput: AVCaptureDeviceInput!
    private var videoDataOutput: AVCaptureVideoDataOutput
    private var depthDataOutput: AVCaptureDepthDataOutput
    private var outputSynchronizer: AVCaptureDataOutputSynchronizer?
    private var outputSynchronizerQueue: DispatchQueue
    private var pinchGestureObservers: NSHashTable<AnyObject> = .weakObjects()
    private var panGestureObservers: NSHashTable<AnyObject> = .weakObjects()
    
    //helpers
    private var sessionSetupResult: SessionSetupResult
    private var renderingEnabled: Bool = true
    private var uiOrientation: UIInterfaceOrientation = .portrait
    
    init() {
        self.sessionSetupResult = .success
        self.captureSession = AVCaptureSession()
        self.videoDataOutput = AVCaptureVideoDataOutput()
        self.depthDataOutput = AVCaptureDepthDataOutput()
        self.sessionQueue = DispatchQueue(label: "session_queue", attributes: [], autoreleaseFrequency: .workItem)
        self.outputSynchronizerQueue = DispatchQueue(label: "video_data_queue_synchronized", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
        self.videDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera], mediaType: .video, position: .front)
        super.init(nibName: nil, bundle: nil)
        print("[DepthDataViewController]: init")
    }
    
    deinit {
        print("[DepthDataViewController]: deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizationStatus { [weak self] in
            self?.configureSession()
        }
        
        addMetalView()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
        self.metalView.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureHandler))
        self.metalView.addGestureRecognizer(pinchGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let window = UIApplication.shared.connectedScenes.first as? UIWindowScene
        self.uiOrientation = window?.interfaceOrientation ?? .portrait
        
        sessionQueue.async { [weak self] in
            self?.startSession()
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
        metalView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        metalView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        metalView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        metalView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}


//MARK: - Configure Capture Session

extension DepthDataViewController {
    
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
            
            // todo: add rotation camera for metal preview
            
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
}

// MARK: - AVCaptureDataOutputSynchronizerDelegate

extension DepthDataViewController: AVCaptureDataOutputSynchronizerDelegate {
    func dataOutputSynchronizer(_ synchronizer: AVCaptureDataOutputSynchronizer, didOutput synchronizedDataCollection: AVCaptureSynchronizedDataCollection) {
//        guard renderingEnabled else { return }
//
//        //read all outputs
//        guard
//            let syncedDepthData: AVCaptureSynchronizedDepthData = synchronizedDataCollection.synchronizedData(for: depthDataOutput) as? AVCaptureSynchronizedDepthData,
//            let syncedVideoData: AVCaptureSynchronizedSampleBufferData = synchronizedDataCollection.synchronizedData(for: videoDataOutput) as? AVCaptureSynchronizedSampleBufferData
//        else {
//            return
//        }
//
//        guard !syncedDepthData.depthDataWasDropped || !syncedVideoData.sampleBufferWasDropped else { return }
//
//        let depthData = syncedDepthData.depthData
//        let depthPixelBuffer = depthData.depthDataMap
//        let sampleBuffer = syncedVideoData.sampleBuffer
//
//        guard
//            let videoPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
//            let formatDiscription = CMSampleBufferGetFormatDescription(sampleBuffer)
//        else {
//            return
//        }
//
//        //todo: cloud point index
//        self.renderer.setDepthFrame(depth: depthData, withTexture: videoPixelBuffer)
        
        
        if !renderingEnabled {
            return
        }
        
        // Read all outputs
        guard renderingEnabled,
            let syncedDepthData: AVCaptureSynchronizedDepthData =
            synchronizedDataCollection.synchronizedData(for: depthDataOutput) as? AVCaptureSynchronizedDepthData,
            let syncedVideoData: AVCaptureSynchronizedSampleBufferData =
            synchronizedDataCollection.synchronizedData(for: videoDataOutput) as? AVCaptureSynchronizedSampleBufferData else {
                // only work on synced pairs
                return
        }
        
        if syncedDepthData.depthDataWasDropped || syncedVideoData.sampleBufferWasDropped {
            return
        }
        
        let depthData = syncedDepthData.depthData
        let depthPixelBuffer = depthData.depthDataMap
        let sampleBuffer = syncedVideoData.sampleBuffer
        guard let videoPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
            let formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer) else {
                return
        }
        
        
        self.renderer?.setDepthFrame(depth: depthData, withTexture: videoPixelBuffer)
    }
    
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
