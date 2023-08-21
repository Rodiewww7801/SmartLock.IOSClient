//
//  UserInfoViewController.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import UIKit

class UserInfoViewController: UIViewController {
    private var userInfoView: UserInfoViewCell!
    private var viewModel: UserInfoViewModel
    private var buttonStackView: UIStackView!
    private var updateUserButton: UIButton!
    private var deleteUserButton: UIButton!
    private var loadingScreen = FDLoadingScreen()
    
    var onUpdateUserAction: ((UserInfo)->Void)?
    var onDeleteUserAction: (()->Void)?
    var onBackTapped: (()->Void)?
    
    init(with viewModel: UserInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadModel()
    }
    
    private func configureViews() {
        self.view.backgroundColor = .white
        configureUserInfoView()
        configureButtonStackView()
        configureManagmentStackView()
    }
    
    private func loadModel() {
        loadingScreen.show(on: self.view)
        viewModel.configure { [weak self] model in
            DispatchQueue.main.async {
                self?.userInfoView.updateData(model)
                self?.view.setNeedsLayout()
                self?.view.layoutIfNeeded()
                self?.loadingScreen.stop()
            }
        }
    }
    
    private func configureUserInfoView() {
        userInfoView = UserInfoViewCell()
        userInfoView.configure()
        self.view.addSubview(userInfoView)
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        userInfoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        userInfoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        userInfoView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
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
        
        updateUserButton = UIButton(type: .system)
        updateUserButton.backgroundColor = .white
        updateUserButton.contentHorizontalAlignment = .left
        updateUserButton.setTitle("Edit info", for: .normal)
        updateUserButton.setTitleColor(.systemGray, for: .normal)
        updateUserButton.addTarget(self, action: #selector(updateUser), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(updateUserButton)
        updateUserButton.translatesAutoresizingMaskIntoConstraints = false
        updateUserButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        updateUserButton.widthAnchor.constraint(equalTo: self.buttonStackView.widthAnchor).isActive = true
        
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
    
    @objc private func updateUser() {
        guard let userInfo = viewModel.userInfoModel else { return }
        self.onUpdateUserAction?(userInfo)
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
        
        guard let firstName = viewModel.userInfoModel?.user.firstName, let lastName = viewModel.userInfoModel?.user.lastName else { return }
        FDAlert()
            .createWith(title: "Are you sure you want to delete \(firstName) \(lastName)?", message: nil)
            .addAction(title: "Cancel", style: .cancel, handler: nil)
            .addAction(title: "Yes", style: .default, handler: {
                startDeleteUser()
            })
            .present(on: self)
    }
}
