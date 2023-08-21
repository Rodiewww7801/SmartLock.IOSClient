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
        buttonStackView.contentMode = .left
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
        userPhotosButton.contentHorizontalAlignment = .left
        userPhotosButton.setTitle("Photos", for: .normal)
        userPhotosButton.setTitleColor(.systemGray, for: .normal)
        userPhotosButton.addTarget(self, action: #selector(getUserPhotos), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(userPhotosButton)
        userPhotosButton.translatesAutoresizingMaskIntoConstraints = false
        userPhotosButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userPhotosButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor).isActive = true
        
        addDividerIn(buttonStackView)
        
        updateUserButton = UIButton(type: .system)
        updateUserButton.backgroundColor = .white
        updateUserButton.contentHorizontalAlignment = .left
        updateUserButton.setTitle("Edit info", for: .normal)
        updateUserButton.setTitleColor(.systemGray, for: .normal)
        updateUserButton.addTarget(self, action: #selector(updateUser), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(updateUserButton)
        updateUserButton.translatesAutoresizingMaskIntoConstraints = false
        updateUserButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        updateUserButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor).isActive = true
        
        addDividerIn(buttonStackView)
        
        deleteUserButton = UIButton(type: .system)
        deleteUserButton.backgroundColor = .white
        deleteUserButton.contentHorizontalAlignment = .left
        deleteUserButton.setTitle("Delete user", for: .normal)
        deleteUserButton.setTitleColor(.red, for: .normal)
        deleteUserButton.addTarget(self, action: #selector(deleteUser), for: .touchUpInside)
       
        buttonStackView.addArrangedSubview(deleteUserButton)
        deleteUserButton.translatesAutoresizingMaskIntoConstraints = false
        deleteUserButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        deleteUserButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor).isActive = true
        
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
    
    @objc private func deleteUser() {
        func startDeleteUser() {
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
        
        guard let firstName = viewModel.userInfo?.user.firstName, let lastName = viewModel.userInfo?.user.lastName else { return }
        FDAlert()
            .createWith(title: "Are you sure you want to delete \(firstName) \(lastName)?", message: nil)
            .addAction(title: "Cancel", style: .cancel, handler: nil)
            .addAction(title: "Yes", style: .default, handler: {
                startDeleteUser()
            })
            .present(on: self)
    }
    
    @objc private func updateUser() {
        guard let userInfo = viewModel.userInfo else { return }
        self.onUpdateUserAction?(userInfo)
    }
}
