//
//  MainCameraVC.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 28.03.2023.
//

import UIKit

class MainCameraVC: UIViewController {
    private var lastPhotoButton: UIButton = UIButton()
    private var capturePhotoView: UIView = UIView()
    private var changeCameraButton: UIButton = UIButton()
    private var bottomButtonsFirstStack: UIStackView = UIStackView()
    private var hideBackgroundButton: UIButton = UIButton()
    private var debugModeButton: UIButton = UIButton()
    private var bottomButtonsSecondStack: UIStackView = UIStackView()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .black
        configureViews()
    }
    
    private func configureViews() {
        configureBottomButtonsFirstStack()
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
        self.capturePhotoView = UIView()
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
        
    }
}
