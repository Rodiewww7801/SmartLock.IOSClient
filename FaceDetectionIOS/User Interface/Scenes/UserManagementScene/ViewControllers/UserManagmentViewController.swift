//
//  UserManagmentViewController.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 17.08.2023.
//

import UIKit
import PhotosUI

class UserManagmentViewController: UIViewController {
    private var userInfoView: UserInfoViewCell!
    private var buttonStackView: UIStackView!
    private var userPhotosButton: UIButton!
    private var addUserPhotosButton: UIButton!
    private var updateUserButton: UIButton!
    private var deleteUserButton: UIButton!
    private let viewModel: UserManagmentViewModel
    private let loadingScreen = FDLoadingScreen()
    
    var onGetUserPhotosAction: ((_ userId: String)->Void)?
    var onDeleteUserAction: (()->Void)?
    var onUpdateUserAction: ((UserInfo)->Void)?
    
    init(with viewModel: UserManagmentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    private func loadData() {
        self.loadingScreen.show(on: self.view)
        self.viewModel.loadData { [weak self] in
            DispatchQueue.main.async {
                guard let self = self, let userInfo = self.viewModel.userInfo else { return }
                self.userInfoView.updateData(userInfo)
                self.loadingScreen.stop()
            }
        }
    }
    
    private func configureViews() {
        self.view.backgroundColor = .white
        configureUserInfoView()
        configureButtonStackView()
        configureManagmentStackView()
    }
    
    private func configureUserInfoView() {
        userInfoView = UserInfoViewCell()
        userInfoView.configure()
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(userInfoView)
        userInfoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        userInfoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        userInfoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    private func configureButtonStackView() {
        buttonStackView = UIStackView()
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 0
        
        self.view.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 20).isActive = true
        buttonStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        buttonStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
        buttonStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
    }
    
    
    private func configureManagmentStackView() {
        addDividerIn(buttonStackView)
        
        userPhotosButton = UIButton(type: .system)
        userPhotosButton.backgroundColor = .white
        userPhotosButton.setTitle("User photos", for: .normal)
        userPhotosButton.setTitleColor(.systemBlue, for: .normal)
        userPhotosButton.addTarget(self, action: #selector(getUserPhotos), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(userPhotosButton)
        userPhotosButton.translatesAutoresizingMaskIntoConstraints = false
        userPhotosButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addDividerIn(buttonStackView)
        
        addUserPhotosButton = UIButton(type: .system)
        addUserPhotosButton.backgroundColor = .white
        addUserPhotosButton.setTitle("Add photos", for: .normal)
        addUserPhotosButton.setTitleColor(.systemBlue, for: .normal)
        addUserPhotosButton.addTarget(self, action: #selector(addUserPhotos), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(addUserPhotosButton)
        addUserPhotosButton.translatesAutoresizingMaskIntoConstraints = false
        addUserPhotosButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        addDividerIn(buttonStackView)
        
        updateUserButton = UIButton(type: .system)
        updateUserButton.backgroundColor = .white
        updateUserButton.setTitle("Update user", for: .normal)
        updateUserButton.setTitleColor(.systemBlue, for: .normal)
        updateUserButton.addTarget(self, action: #selector(updateUser), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(updateUserButton)
        updateUserButton.translatesAutoresizingMaskIntoConstraints = false
        updateUserButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addDividerIn(buttonStackView)
        
        addUserPhotosButton = UIButton(type: .system)
        addUserPhotosButton.backgroundColor = .white
        addUserPhotosButton.setTitle("Delete user", for: .normal)
        addUserPhotosButton.setTitleColor(.red, for: .normal)
        addUserPhotosButton.addTarget(self, action: #selector(deleteUser), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(addUserPhotosButton)
        addUserPhotosButton.translatesAutoresizingMaskIntoConstraints = false
        addUserPhotosButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addDividerIn(buttonStackView)
    }
    
    private func addDividerIn(_ stackView: UIStackView) {
        let divider = UIView()
        divider.layer.backgroundColor = UIColor.systemGray6.cgColor
        
        stackView.addArrangedSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }
    
    @objc private func getUserPhotos() {
        guard let userId = viewModel.userInfo?.user.id else { return }
        self.onGetUserPhotosAction?(userId)
    }
    
    @objc private func addUserPhotos() {
        configurePhotoPickerViewController()
    }
    
    @objc private func deleteUser() {
        loadingScreen.show(on: self.view)
        viewModel.deleteUser { isSuccess in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                loadingScreen.stop()
                if isSuccess {
                    FDAlert()
                        .createWith(title: "User deleted", message: nil)
                        .addAction(title: "Ok", style: .default, handler: {
                            self.onDeleteUserAction?()
                        })
                        .present(on: self)
                }
            }
        }
    }
    
    @objc private func updateUser() {
        guard let userInfo = viewModel.userInfo else { return }
        self.onUpdateUserAction?(userInfo)
    }
    
    private func configurePhotoPickerViewController() {
            var configuration = PHPickerConfiguration(photoLibrary: .shared())
            configuration.filter = .images
            configuration.selectionLimit = .max
            let viewController = PHPickerViewController(configuration: configuration)
            viewController.delegate = self
            self.present(viewController, animated: true)
    }
}

extension UserManagmentViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        var images = [UIImage]()
        let dispatchGroup = DispatchGroup()
        results.forEach { result in
            dispatchGroup.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                defer {
                    dispatchGroup.leave()
                }
                guard let image = reading as? UIImage, error == nil else {
                    print("[UserManagmentViewController]: \(String(describing: error))")
                    return
                }
                images.append(image)
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            if !images.isEmpty {
                self.loadingScreen.show(on: self.view)
                self.viewModel.loadImages(images: images) { isSuccess in
                    if isSuccess {
                        DispatchQueue.main.async {
                            FDAlert()
                                .createWith(title: "Success", message: "\(images.count) was added successfully")
                                .addAction(title: "Ok", style: .default, handler: {
                                    self.loadData()
                                })
                                .present(on: self)
                        }
                    }
                    self.loadingScreen.stop()
                }
            }
            picker.dismiss(animated: true)
        }
    }
}
