//
//  MainCameraVC.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 28.03.2023.
//

import UIKit

class MainCameraVC: UIViewController {
    private var lastPhotoButton: UIButton = UIButton()
    private var capturePhotoView: FDFadeAnimatedButton = FDFadeAnimatedButton()
    private var changeCameraButton: UIButton = UIButton()
    private var bottomButtonsFirstStack: UIStackView = UIStackView()
    private var hideBackgroundButton: FDFadeAnimatedButton = FDFadeAnimatedButton()
    private var hideBackgroundLabel: UILabel = UILabel()
    private var debugModeButton: FDFadeAnimatedButton = FDFadeAnimatedButton()
    private var debugModeLabel: UILabel = UILabel()
    private var bottomButtonsSecondStack: UIStackView = UIStackView()
    private var faceDetectionStateLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .black
        configureViews()
    }
    
    private func configureViews() {
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
        self.lastPhotoButton = UIButton(type: .system)
        let photoFillRectangeImage = UIImage(systemName: "photo.fill.on.rectangle.fill", withConfiguration: lightImageConiguration)
        self.lastPhotoButton.setImage(photoFillRectangeImage, for: .normal)
        self.lastPhotoButton.contentHorizontalAlignment = .fill
        self.lastPhotoButton.contentVerticalAlignment = .fill
        self.lastPhotoButton.imageView?.contentMode = .scaleAspectFit
        self.lastPhotoButton.tintColor = .white
        self.bottomButtonsFirstStack.addArrangedSubview(lastPhotoButton)
        self.lastPhotoButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.lastPhotoButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //add capturePhotoButton
       
        self.capturePhotoView = FDFadeAnimatedButton()
        capturePhotoView.widthAnchor.constraint(equalToConstant: 77).isActive = true
        capturePhotoView.heightAnchor.constraint(equalToConstant: 77).isActive = true
        self.bottomButtonsFirstStack.addArrangedSubview(capturePhotoView)

        
        let capturePhotoCircleImageView = UIImageView(image: UIImage(systemName: "circle", withConfiguration: lightImageConiguration))
        let capturePhotoCircleFillImageView = UIImageView(image: UIImage(systemName: "circle.fill"))
        
        capturePhotoCircleImageView.contentMode = .scaleAspectFit
        capturePhotoCircleImageView.tintColor = .white
        capturePhotoCircleImageView.translatesAutoresizingMaskIntoConstraints = false
        capturePhotoView.addSubview(capturePhotoCircleImageView)
        capturePhotoCircleImageView.topAnchor.constraint(equalTo: capturePhotoView.topAnchor).isActive = true
        capturePhotoCircleImageView.bottomAnchor.constraint(equalTo: capturePhotoView.bottomAnchor).isActive = true
        capturePhotoCircleImageView.leadingAnchor.constraint(equalTo: capturePhotoView.leadingAnchor).isActive = true
        capturePhotoCircleImageView.trailingAnchor.constraint(equalTo: capturePhotoView.trailingAnchor).isActive = true
        
        capturePhotoCircleFillImageView.contentMode = .scaleAspectFit
        capturePhotoCircleFillImageView.tintColor = .white
        capturePhotoCircleFillImageView.translatesAutoresizingMaskIntoConstraints = false
        capturePhotoView.addSubview(capturePhotoCircleFillImageView)
        capturePhotoCircleFillImageView.topAnchor.constraint(equalTo: capturePhotoView.topAnchor, constant: 9).isActive = true
        capturePhotoCircleFillImageView.bottomAnchor.constraint(equalTo: capturePhotoView.bottomAnchor, constant: -9).isActive = true
        capturePhotoCircleFillImageView.leadingAnchor.constraint(equalTo: capturePhotoView.leadingAnchor, constant: 9).isActive = true
        capturePhotoCircleFillImageView.trailingAnchor.constraint(equalTo: capturePhotoView.trailingAnchor, constant: -9).isActive = true
        
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
        self.bottomButtonsSecondStack.bottomAnchor.constraint(equalTo: self.bottomButtonsFirstStack.topAnchor, constant: -15).isActive = true
        self.bottomButtonsSecondStack.centerXAnchor.constraint(equalTo: self.bottomButtonsFirstStack.centerXAnchor).isActive = true
        
        // add hideBackgroundLabel
        self.hideBackgroundLabel = UILabel()
        self.hideBackgroundLabel.text = "hide background".uppercased()
        self.hideBackgroundLabel.textColor = .white
        self.hideBackgroundLabel.font = .systemFont(ofSize: 14)
        self.hideBackgroundLabel.translatesAutoresizingMaskIntoConstraints = false
        self.hideBackgroundButton = FDFadeAnimatedButton()
        self.hideBackgroundButton.addSubview(hideBackgroundLabel)
        self.bottomButtonsSecondStack.addArrangedSubview(hideBackgroundButton)
        self.hideBackgroundButton.widthAnchor.constraint(equalTo: hideBackgroundLabel.widthAnchor).isActive = true
        self.hideBackgroundButton.heightAnchor.constraint(equalTo:  hideBackgroundLabel.heightAnchor).isActive = true
        
        // add hideBackgroundLabel
        self.debugModeLabel = UILabel()
        self.debugModeLabel.text = "debug mode".uppercased()
        self.debugModeLabel.textColor = .white
        self.debugModeLabel.font = .systemFont(ofSize: 14)
        self.debugModeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.debugModeButton = FDFadeAnimatedButton()
        self.debugModeButton.addSubview(debugModeLabel)
        self.bottomButtonsSecondStack.addArrangedSubview(debugModeButton)
        self.debugModeButton.widthAnchor.constraint(equalTo: debugModeLabel.widthAnchor).isActive = true
        self.debugModeButton.heightAnchor.constraint(equalTo: debugModeLabel.heightAnchor).isActive = true
    }
    
    private func configureFaceDetectionStateLabel() {
        self.faceDetectionStateLabel = UILabel()
        self.faceDetectionStateLabel.text = "Please go fuck yourself"
        self.faceDetectionStateLabel.textColor = .white
        self.faceDetectionStateLabel.font = .systemFont(ofSize: 18, weight: .light)
        self.faceDetectionStateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(faceDetectionStateLabel)
        self.faceDetectionStateLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.faceDetectionStateLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
}
