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
    private var arSessionQueue: DispatchQueue
    
    //ARKit
    private var arSession: ARSession
    
    //helpers
    private var pinchGestureObservers: NSHashTable<AnyObject> = .weakObjects()
    private var panGestureObservers: NSHashTable<AnyObject> = .weakObjects() // todo: try to use default array
    var showSettings: (()->())?
    
    init() {
        self.arSession = ARSession()
        self.arSessionQueue = DispatchQueue(label: "ar_session_queue", attributes: [], autoreleaseFrequency: .workItem)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSettingsNavigationItem()
        addMetalView()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
        self.metalView.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureHandler))
        self.metalView.addGestureRecognizer(pinchGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        if let faceAnchor = frame.anchors.first as? ARFaceAnchor, faceAnchor.isTracked {
            let uniform =
            renderer.camera!.projectionMatrix *
            renderer.camera!.viewMatrix *
            transform.transformMatrix *
            frame.camera.viewMatrix(for: .portrait) *
            faceAnchor.transform
            
            self.renderer?.setFaceMeshModel(faceAnchor.geometry.vertices, uniform)
        } else {
            self.renderer?.setFaceMeshModel([], float4x4.identity)
        }
        
        if let depthData = frame.capturedDepthData {
            self.renderer?.setDepthFrame(depth: depthData, withTexture: frame.capturedImage)
        }
    }
}
