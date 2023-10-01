//
//  InitialViewController.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 19.08.2023.
//

import UIKit

class InitialViewController: UIViewController {
    private var smartLockStackView: UIStackView!
    private var smartLockButton: UIView!
    private var userProfileStackView: UIStackView!
    private var userProfileButton: UIView!
    private var versionLabel: UILabel!
    
    private var buttonStackView: UIStackView!
    private var divider: UIView!
    
    var onSmartLockAction: (()->())?
    var onProfileAction: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        configureDivider()
        configureButtonStackView()
        configureButtons()
        configureVersionLabel()
    }
    
    private func configureButtonStackView() {
        buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 0
        
        self.view.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        buttonStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        buttonStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    private func configureButtons() {
        smartLockStackView = UIStackView()
        smartLockStackView.axis = .vertical
        smartLockStackView.spacing = 0
        smartLockStackView.alignment = .center
        
        let smartLockImage = UIImageView(image: UIImage(named: "SmartLockIcon"))
        smartLockImage.contentMode = .scaleAspectFit
        smartLockStackView.addArrangedSubview(smartLockImage)
        smartLockImage.translatesAutoresizingMaskIntoConstraints = false
        smartLockImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        smartLockImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        let smartLockLabel = UILabel()
        smartLockLabel.text = "Smart lock"
        smartLockLabel.textColor = .systemBlue
        smartLockLabel.font = .systemFont(ofSize: 14)
        
        smartLockStackView.addArrangedSubview(smartLockLabel)
        smartLockLabel.translatesAutoresizingMaskIntoConstraints = false
        smartLockLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        userProfileStackView = UIStackView()
        userProfileStackView.axis = .vertical
        userProfileStackView.spacing = 0
        userProfileStackView.alignment = .center
        
        let lightImageConiguration = UIImage.SymbolConfiguration(weight: .light)
        let symbolImage = UIImage(systemName: "person", withConfiguration: lightImageConiguration)
        let profileImageView = UIImageView(image: symbolImage)
        userProfileStackView.addArrangedSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        let profileLabel = UILabel()
        profileLabel.text = "User account"
        profileLabel.textColor = .systemBlue
        profileLabel.font = .systemFont(ofSize: 14)
        
        userProfileStackView.addArrangedSubview(profileLabel)
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        profileLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        buttonStackView.addArrangedSubview(smartLockStackView)
        smartLockStackView.translatesAutoresizingMaskIntoConstraints = false
        smartLockStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/2).isActive = true
        buttonStackView.addArrangedSubview(userProfileStackView)
        userProfileStackView.translatesAutoresizingMaskIntoConstraints = false
        userProfileStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/2).isActive = true
        
        smartLockButton = UIView()
        smartLockButton.backgroundColor = .clear
        smartLockButton.alpha = 1
        self.view.addSubview(smartLockButton)
        smartLockButton.translatesAutoresizingMaskIntoConstraints = false
        smartLockButton.heightAnchor.constraint(equalTo: smartLockStackView.heightAnchor).isActive = true
        smartLockButton.widthAnchor.constraint(equalTo: smartLockStackView.widthAnchor).isActive = true
        smartLockButton.leadingAnchor.constraint(equalTo: smartLockStackView.leadingAnchor).isActive = true
        smartLockButton.topAnchor.constraint(equalTo: smartLockStackView.topAnchor).isActive = true
        smartLockButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSmartLockTapped)))
        
        userProfileButton = UIView()
        userProfileButton.backgroundColor =  .clear
        userProfileButton.alpha = 1
        self.view.addSubview(userProfileButton)
        userProfileButton.translatesAutoresizingMaskIntoConstraints = false
        userProfileButton.heightAnchor.constraint(equalTo: userProfileStackView.heightAnchor).isActive = true
        userProfileButton.widthAnchor.constraint(equalTo: userProfileStackView.widthAnchor).isActive = true
        userProfileButton.leadingAnchor.constraint(equalTo: userProfileStackView.leadingAnchor).isActive = true
        userProfileButton.topAnchor.constraint(equalTo: userProfileStackView.topAnchor).isActive = true
        userProfileButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onProfileTapped)))
    }
    
    private func configureDivider() {
        divider = UIView()
        divider.layer.backgroundColor = UIColor.systemGray5.cgColor
        
        self.view.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        divider.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        divider.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -750).isActive = true
        divider.widthAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func configureVersionLabel() {
        versionLabel = UILabel()
        let version = Bundle.main.releaseVersionNumber
        versionLabel.text = "v\(version)"
        versionLabel.textColor = .systemBlue
        versionLabel.font = .systemFont(ofSize: 14)
        
        self.view.addSubview(versionLabel)
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        versionLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        versionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    @objc private func onSmartLockTapped() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.smartLockStackView.backgroundColor = .systemGray6
            self?.smartLockStackView.backgroundColor = .clear
        }
        
        onSmartLockAction?()
    }
    
    @objc private func onProfileTapped() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.userProfileStackView.backgroundColor = .systemGray6
            self?.userProfileStackView.backgroundColor = .clear
        }
        
        onProfileAction?()
    }
}
