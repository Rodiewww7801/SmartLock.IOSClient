//
//  DetectionSceneVC.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 28.03.2023.
//

import UIKit

class DetectionSceneVC: UIViewController {
    private var capturePhotoButton: FDFadeAnimatedButton = FDFadeAnimatedButton()
    private var faceDetectionStateLabel: UILabel = UILabel()
    private var debugView: DebugView!
    private var ellipseLayer: CAShapeLayer = CAShapeLayer()
    private var stateLabelIsAnimating = false
    private var loadingScreen = FDLoadingScreen()
    
    private var viewModel: DetectionSceneViewModel
    var showSettings: (()->())?
    var onBackTapped: (()->())?
    var showDetectionPermission: (()->Void)?
    var showUserCard: ((User)->Void)?
    
    init(with viewModel: DetectionSceneViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        print("[DetectionSceneVC]: init")
        self.viewModel.setPresentedDelegate(self)
    }
    
    deinit {
        print("[DetectionSceneVC]: deinit")
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
        self.view.backgroundColor = .white
        configureViews()
    }
    
    private func configureViews() {
        addSettingsNavigationItem()
        configureCameraCaptureVC()
        configureDebugView()
        configureFaceDetectionStateLabel()
        addEllipse()
    }
    
    private func addSettingsNavigationItem() {
        let settingsNavigationItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(onSettingsTapped))
        self.navigationItem.rightBarButtonItem = settingsNavigationItem
    }
    
    @objc private func onSettingsTapped() {
        self.showSettings?()
    }
    
    private func addEllipse() {
        let faceLayoutGuideFrame = viewModel.faceLayoutGuideFrame
        let ellipseView = UIView(frame: faceLayoutGuideFrame)
        let scaledEllipseSize = CGSize(width: faceLayoutGuideFrame.width - 1, height: faceLayoutGuideFrame.height - 1)
        let ellipsePath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: scaledEllipseSize))
        let ellipseLayer = CAShapeLayer()
        ellipseLayer.path = ellipsePath.cgPath
        ellipseLayer.strokeColor = UIColor.red.cgColor
        ellipseLayer.fillColor = UIColor.clear.cgColor
        ellipseLayer.position = CGPoint(x: (faceLayoutGuideFrame.width - 1) / -2 , y: (faceLayoutGuideFrame.height - 1) / -2)
        ellipseView.layer.addSublayer(ellipseLayer)
        self.ellipseLayer = ellipseLayer
        
        ellipseView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(ellipseView)
        ellipseView.centerXAnchor.constraint(equalTo: self.debugView.centerXAnchor).isActive = true
        ellipseView.centerYAnchor.constraint(equalTo: self.debugView.centerYAnchor).isActive = true
    }
    
    private func updateEllipseState() {
        self.ellipseLayer.strokeColor = viewModel.faceValidationState ? UIColor.green.cgColor : UIColor.red.cgColor
    }
    
    private func configureFaceDetectionStateLabel() {
        self.faceDetectionStateLabel = UILabel()
        self.faceDetectionStateLabel.textColor = .white
        self.faceDetectionStateLabel.font = .systemFont(ofSize: 18, weight: .light)
        self.faceDetectionStateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(faceDetectionStateLabel)
        self.faceDetectionStateLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.faceDetectionStateLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
    }
    
    private func conigureTextFaceDetectionStateLabel() {
        var textForLabel = ""
        
        if viewModel.faceValidationState {
            textForLabel = "Perfect"
        } else if viewModel.isAcceptableBounds == .detectedFaceTooSmall {
            textForLabel = "Face is too far from the camera"
        } else if viewModel.isAcceptableBounds == .detectedFaceTooLarge {
            textForLabel = "Face is too close"
        } else if viewModel.isAcceptableBounds == .detectedFaceOffCentre {
            textForLabel = "Face is not in center"
        } else if !viewModel.isAcceptableRoll || !viewModel.isAcceptablePitch || !viewModel.isAcceptableYaw {
            textForLabel = "Look straight at the camera"
        } else if !viewModel.isAcceptableQuality {
            textForLabel = "Quality is too low "
        } else {
            textForLabel = "Cannot use detection"
        }
        
        self.faceDetectionStateLabel.text = textForLabel
    }
    
    private func configureDebugView() {
        self.debugView = DebugView(with: self.viewModel)
        debugView.isHidden = true
        self.view.addSubview(debugView)
        debugView.translatesAutoresizingMaskIntoConstraints = false
        debugView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        debugView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        debugView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        debugView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    private func configureCameraCaptureVC() {
        let cameraCaptureVC = CameraCaptureVC(with: viewModel)
        self.addChild(cameraCaptureVC)
        cameraCaptureVC.showDetectionPermission = showDetectionPermission
        cameraCaptureVC.didMove(toParent: self)

        self.view.addSubview(cameraCaptureVC.view)
        cameraCaptureVC.view.translatesAutoresizingMaskIntoConstraints = false
        cameraCaptureVC.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        cameraCaptureVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        cameraCaptureVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        cameraCaptureVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
}

// MARK: - DetectionScenePresentedDelegate

extension DetectionSceneVC: DetectionScenePresentedDelegate {
    func showLoadingScreen() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadingScreen.show(on: self.view)
        }
       
    }
    
    func stopLoadingScreen() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadingScreen.stop()
        }
    }
    
    func capturePhotoObservation(image: UIImage) {
        //
    }
    
    func updateFaceGeometry() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.debugView.setNeedsLayout()
            self.debugView.setNeedsDisplay()
        }
    }
    
    func updateFaceState() {
        DispatchQueue.main.async { [weak self] in
            self?.conigureTextFaceDetectionStateLabel()
            self?.updateEllipseState()
        }
    }
    
    func onShowUserCard(user: User) {
        DispatchQueue.main.async { [weak self] in
            self?.showUserCard?(user)
        }
    }
}

// MARK: - DetectionSceneSettingsDelegate

extension DetectionSceneVC: DetectionSceneSettingsDelegate {
    func debugMode() {
        debugView.isHidden.toggle()
        viewModel.debugModeEnabled = !debugView.isHidden
    }
}

// MARK: - ModalPresentedViewDelegate

extension DetectionSceneVC: ModalPresentedViewDelegate {
    func onViewWillDisappear() {
        viewModel.unvalidateFace()
    }
}

