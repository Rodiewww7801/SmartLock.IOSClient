//
//  MainCameraVC.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 28.03.2023.
//

import UIKit

class MainCameraInterfaceVC: UIViewController {
    private var lastPhotoView: UIImageView = UIImageView()
    private var capturePhotoButton: FDFadeAnimatedButton = FDFadeAnimatedButton()
    private var changeCameraButton: UIButton = UIButton()
    private var bottomButtonsFirstStack: UIStackView = UIStackView()
    private var hideBackgroundButton: FDFadeAnimatedButton = FDFadeAnimatedButton()
    private var hideBackgroundLabel: UILabel = UILabel()
    private var debugModeButton: FDFadeAnimatedButton = FDFadeAnimatedButton()
    private var debugModeLabel: UILabel = UILabel()
    private var bottomButtonsSecondStack: UIStackView = UIStackView()
    private var faceDetectionStateLabel: UILabel = UILabel()
    private var debugView: DebugView!
    private var stateLabelIsAnimating = false
    
    private var viewModel: MainCameraViewModel?
    
    init(with viewModel: MainCameraViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.viewModel?.setPresentedDelegate(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .black
        configureViews()
    }
    
    private func configureViews() {
        configureCameraCaptureVC()
        configureDebugView()
        configureBottomButtonsFirstStack()
        configureBottomButtonsSecondStack()
        configureFaceDetectionStateLabel()
    }
    
    private func configureBottomButtonsFirstStack() {
        self.bottomButtonsFirstStack = UIStackView()
        self.bottomButtonsFirstStack.axis = .horizontal
        self.bottomButtonsFirstStack.alignment = .center
        self.bottomButtonsFirstStack.distribution = .equalCentering
        self.bottomButtonsFirstStack.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomButtonsFirstStack)
        self.bottomButtonsFirstStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -70).isActive = true
        self.bottomButtonsFirstStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
        self.bottomButtonsFirstStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
        
        // add lastPhotoButton
        let lightImageConiguration = UIImage.SymbolConfiguration(weight: .light)
        let photoFillRectangeImage = UIImage(systemName: "photo.fill.on.rectangle.fill", withConfiguration: lightImageConiguration)
        self.lastPhotoView = UIImageView(image: photoFillRectangeImage)
        self.lastPhotoView.tintColor = .white
        self.lastPhotoView.contentMode = .scaleAspectFit
        self.bottomButtonsFirstStack.addArrangedSubview(lastPhotoView)
        self.lastPhotoView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.lastPhotoView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //add capturePhotoButton
        self.capturePhotoButton = FDFadeAnimatedButton()
        self.capturePhotoButton.addAction(capturePhotoButtonTapped, for: .touchDown)
        capturePhotoButton.widthAnchor.constraint(equalToConstant: 77).isActive = true
        capturePhotoButton.heightAnchor.constraint(equalToConstant: 77).isActive = true
        self.bottomButtonsFirstStack.addArrangedSubview(capturePhotoButton)

        
        let capturePhotoCircleImageView = UIImageView(image: UIImage(systemName: "circle", withConfiguration: lightImageConiguration))
        let capturePhotoCircleFillImageView = UIImageView(image: UIImage(systemName: "circle.fill"))
        
        capturePhotoCircleImageView.contentMode = .scaleAspectFit
        capturePhotoCircleImageView.tintColor = .white
        capturePhotoCircleImageView.translatesAutoresizingMaskIntoConstraints = false
        capturePhotoButton.addSubview(capturePhotoCircleImageView)
        capturePhotoCircleImageView.topAnchor.constraint(equalTo: capturePhotoButton.topAnchor).isActive = true
        capturePhotoCircleImageView.bottomAnchor.constraint(equalTo: capturePhotoButton.bottomAnchor).isActive = true
        capturePhotoCircleImageView.leadingAnchor.constraint(equalTo: capturePhotoButton.leadingAnchor).isActive = true
        capturePhotoCircleImageView.trailingAnchor.constraint(equalTo: capturePhotoButton.trailingAnchor).isActive = true
        
        capturePhotoCircleFillImageView.contentMode = .scaleAspectFit
        capturePhotoCircleFillImageView.tintColor = .white
        capturePhotoCircleFillImageView.translatesAutoresizingMaskIntoConstraints = false
        capturePhotoButton.addSubview(capturePhotoCircleFillImageView)
        capturePhotoCircleFillImageView.topAnchor.constraint(equalTo: capturePhotoButton.topAnchor, constant: 9).isActive = true
        capturePhotoCircleFillImageView.bottomAnchor.constraint(equalTo: capturePhotoButton.bottomAnchor, constant: -9).isActive = true
        capturePhotoCircleFillImageView.leadingAnchor.constraint(equalTo: capturePhotoButton.leadingAnchor, constant: 9).isActive = true
        capturePhotoCircleFillImageView.trailingAnchor.constraint(equalTo: capturePhotoButton.trailingAnchor, constant: -9).isActive = true
        
        // add lastPhotoButton
        self.changeCameraButton = UIButton(type: .system)
        let circlepathImage = UIImage(systemName: "arrow.triangle.2.circlepath", withConfiguration: lightImageConiguration)
        self.changeCameraButton.setImage(circlepathImage, for: .normal)
        self.changeCameraButton.contentHorizontalAlignment = .fill
        self.changeCameraButton.contentVerticalAlignment = .fill
        self.changeCameraButton.imageView?.contentMode = .scaleAspectFit
        self.changeCameraButton.tintColor = .white
        self.bottomButtonsFirstStack.addArrangedSubview(changeCameraButton)
        self.changeCameraButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.changeCameraButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configureBottomButtonsSecondStack() {
        self.bottomButtonsSecondStack = UIStackView()
        self.bottomButtonsSecondStack.alignment = .center
        self.bottomButtonsSecondStack.distribution = .equalCentering
        self.bottomButtonsSecondStack.spacing = 25
        self.bottomButtonsSecondStack.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomButtonsSecondStack)
        self.bottomButtonsSecondStack.bottomAnchor.constraint(equalTo: self.bottomButtonsFirstStack.topAnchor, constant: -20).isActive = true
        self.bottomButtonsSecondStack.centerXAnchor.constraint(equalTo: self.bottomButtonsFirstStack.centerXAnchor).isActive = true
        
        // add hideBackgroundLabel
        self.hideBackgroundLabel = UILabel()
        self.hideBackgroundLabel.text = "hide background".uppercased()
        self.hideBackgroundLabel.textColor = .white
        self.hideBackgroundLabel.font = .systemFont(ofSize: 14)
        self.hideBackgroundLabel.translatesAutoresizingMaskIntoConstraints = false
        self.hideBackgroundButton = FDFadeAnimatedButton()
        self.hideBackgroundButton.addAction(hideBackgroundTapped, for: .touchDown)
        self.hideBackgroundButton.addSubview(hideBackgroundLabel)
        self.bottomButtonsSecondStack.addArrangedSubview(hideBackgroundButton)
        self.hideBackgroundButton.widthAnchor.constraint(equalTo: hideBackgroundLabel.widthAnchor).isActive = true
        self.hideBackgroundButton.heightAnchor.constraint(equalTo:  hideBackgroundLabel.heightAnchor).isActive = true
        
        // add debugMode
        self.debugModeLabel = UILabel()
        self.debugModeLabel.text = "debug mode".uppercased()
        self.debugModeLabel.textColor = .white
        self.debugModeLabel.font = .systemFont(ofSize: 14)
        self.debugModeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.debugModeButton = FDFadeAnimatedButton()
        self.debugModeButton.addAction(debugModeButtonTapped, for: .touchDown)
        self.debugModeButton.addSubview(debugModeLabel)
        self.bottomButtonsSecondStack.addArrangedSubview(debugModeButton)
        self.debugModeButton.widthAnchor.constraint(equalTo: debugModeLabel.widthAnchor).isActive = true
        self.debugModeButton.heightAnchor.constraint(equalTo: debugModeLabel.heightAnchor).isActive = true
    }
    
    private func configureFaceDetectionStateLabel() {
        self.faceDetectionStateLabel = UILabel()
        self.faceDetectionStateLabel.textColor = .white
        self.faceDetectionStateLabel.font = .systemFont(ofSize: 18, weight: .light)
        self.faceDetectionStateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(faceDetectionStateLabel)
        self.faceDetectionStateLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.faceDetectionStateLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    private func conigureTextFaceDetectionStateLabel() {
        guard let viewModel = viewModel else { return }
        var textForLabel = ""
        if viewModel.hasDetectedValidFace {
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
        self.debugView = DebugView()
        self.debugView.viewModel = self.viewModel
        debugView.isHidden = true
        self.view.addSubview(debugView)
        debugView.translatesAutoresizingMaskIntoConstraints = false
        debugView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        debugView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        debugView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        debugView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    private func configureCameraCaptureVC() {
        guard let viewModel = self.viewModel else { return }
        let cameraCaptureVC = CameraCaptureVC(with: viewModel)
        self.addChild(cameraCaptureVC)
        cameraCaptureVC.view.frame = self.view.frame
        self.view.addSubview(cameraCaptureVC.view)
        cameraCaptureVC.didMove(toParent: self)
    }
    
    private func hideBackgroundTapped() {
        self.viewModel?.hideBackgroundModeEnabled.toggle()
        let state = self.viewModel?.hideBackgroundModeEnabled ?? false
        self.hideBackgroundLabel.textColor = state ? .yellow : .white
    }
    
    private func debugModeButtonTapped() {
        debugView.isHidden.toggle()
        self.debugModeLabel.textColor = debugView.isHidden ?  .white : .yellow
    }
    
    private func capturePhotoButtonTapped() {
        self.viewModel?.perform(action: .takePhoto)
    }
}

extension MainCameraInterfaceVC: MainCameraPresentedDelegate {
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
        }
    }
    
    func capturePhotoObservation(image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.lastPhotoView.image = image
            self?.lastPhotoView.tintColor = .clear
        }
        
    }
}
