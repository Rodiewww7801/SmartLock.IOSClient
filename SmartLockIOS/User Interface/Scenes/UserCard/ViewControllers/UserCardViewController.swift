//
//  UserCardViewController.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 27.08.2023.
//

import Foundation
import UIKit

class UserCardViewController: UIViewController {
    private var userInfoView: UserInfoViewCell!
    private var viewModel: UserCardViewModel
    
    var modalDelegate: ModalPresentedViewDelegate?
    
    init(with viewModel: UserCardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        modalDelegate?.onViewWillDisappear()
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureViews() {
        self.view.backgroundColor = .white
        configureUserInfoView()
    }
    
    private func configureUserInfoView() {
        userInfoView = UserInfoViewCell()
        userInfoView.configure()
        userInfoView.updateData(viewModel.user)
        self.view.addSubview(userInfoView)
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        userInfoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        userInfoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        userInfoView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
}
