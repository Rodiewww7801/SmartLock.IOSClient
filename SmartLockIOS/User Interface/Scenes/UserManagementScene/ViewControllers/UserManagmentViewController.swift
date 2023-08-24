//
//  UserManagmentViewController.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 17.08.2023.
//

import UIKit
import PhotosUI

class UserManagmentViewController: UIViewController {
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var userInfoView: UserInfoViewCell!
    private var buttonStackView: UIStackView!
    private var userPhotosButton: UIButton!
    private var updateUserButton: UIButton!
    private var lockHistoriesButton: UIButton!
    private var userAccessesButton: UIButton!
    private var deleteUserButton: UIButton!
    private let viewModel: UserManagmentViewModel
    private let loadingScreen = FDLoadingScreen()
    
    var onGetUserPhotosAction: ((_ userId: String)->Void)?
    var onDeleteUserAction: (()->Void)?
    var onUpdateUserAction: ((User)->Void)?
    var onGetHistroriesAction: ((String)->Void)?
    var onGetUserLockAccessesAction: ((String)->Void)?
    
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
        configureScrollView()
        configureUserInfoView()
        configureButtonStackView()
        configureManagmentStackView()
    }
    
    private func configureScrollView() {
        scrollView = UIScrollView()
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero

        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: -100).isActive = true
    }
    
    private func configureUserInfoView() {
        userInfoView = UserInfoViewCell()
        userInfoView.configure()
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(userInfoView)
        userInfoView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        userInfoView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        userInfoView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    }
    
    private func configureButtonStackView() {
        buttonStackView = UIStackView()
        buttonStackView.axis = .vertical
        buttonStackView.contentMode = .left
        buttonStackView.spacing = 0
        
        self.contentView.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 20).isActive = true
        buttonStackView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        buttonStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 25).isActive = true
        buttonStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -25).isActive = true
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
        
        userAccessesButton = UIButton(type: .system)
        userAccessesButton.backgroundColor = .white
        userAccessesButton.contentHorizontalAlignment = .left
        userAccessesButton.setTitle("Accesses", for: .normal)
        userAccessesButton.setTitleColor(.systemGray, for: .normal)
        userAccessesButton.addTarget(self, action: #selector(onGetUserLockAccessesTapped), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(userAccessesButton)
        userAccessesButton.translatesAutoresizingMaskIntoConstraints = false
        userAccessesButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userAccessesButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor).isActive = true
        
        addDividerIn(buttonStackView)
        
        lockHistoriesButton = UIButton(type: .system)
        lockHistoriesButton.backgroundColor = .white
        lockHistoriesButton.contentHorizontalAlignment = .left
        lockHistoriesButton.setTitle("History", for: .normal)
        lockHistoriesButton.setTitleColor(.systemGray, for: .normal)
        lockHistoriesButton.addTarget(self, action: #selector(onHistoriesTapped), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(lockHistoriesButton)
        lockHistoriesButton.translatesAutoresizingMaskIntoConstraints = false
        lockHistoriesButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        lockHistoriesButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor).isActive = true
        
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
        deleteUserButton.setTitle("Delete", for: .normal)
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
        guard let userId = viewModel.userInfo?.id else { return }
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
                            .createWith(title: "User was deleted", message: nil)
                            .addAction(title: "Ok", style: .default, handler: {
                                self.onDeleteUserAction?()
                            })
                            .present(on: self)
                    }
                }
            }
        }
        
        guard let firstName = viewModel.userInfo?.firstName, let lastName = viewModel.userInfo?.lastName else { return }
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
    
    @objc private func onHistoriesTapped() {
        self.onGetHistroriesAction?(self.viewModel.userId)
    }
    
    @objc private func onGetUserLockAccessesTapped()  {
        self.onGetUserLockAccessesAction?(self.viewModel.userId)
    }
}
