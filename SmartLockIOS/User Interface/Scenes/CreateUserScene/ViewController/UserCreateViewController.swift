//
//  UserCreateViewController.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import UIKit

class UserCreateViewController: UIViewController {
    private var userCreateView: UserCreateView!
    private var viewModel: CreateUserViewModel
    private var loadingScreen = FDLoadingScreen()
    
    var modalDelegate: ModalPresentedViewDelegate?
    var onUserCreatedFinish: (()->())?
    
    init(with viewModel: CreateUserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        configureViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        modalDelegate?.onViewWillDisappear()
    }
    
    private func configureViews() {
        configureUserCreateView()
    }
    
    private func configureUserCreateView() {
        self.userCreateView = UserCreateView()
        userCreateView.onCreateAction = onCreateUser
        self.view.addSubview(userCreateView)
        userCreateView.translatesAutoresizingMaskIntoConstraints = false
        userCreateView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        userCreateView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        userCreateView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        userCreateView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func onCreateUser(_ dto: CreateUserRequestDTO) {
        loadingScreen.show(on: self.view)
        viewModel.createUser(dto) { [weak self] isSuccess in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if isSuccess {
                    FDAlert()
                        .createWith(title: "User created", message: nil)
                        .addAction(title: "Ok", style: .default, handler: {
                            self.dismiss(animated: true)
                        })
                        .present(on: self)
                } else {
                    self.dismiss(animated: true)
                }
                self.loadingScreen.stop()
            }
        }
    }
}
