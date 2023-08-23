//
//  AddLockViewController.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 22.08.2023.
//

import Foundation
import UIKit

class AddLockViewController: UIViewController {
    private var addLockView: AddLockView!
    private var viewModel: AddLockViewModel
    private var loadingScreen = FDLoadingScreen()
    
    var modalDelegate: ModalPresentedViewDelegate?
    
    init(with viewModel: AddLockViewModel) {
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
        configureAddCreateView()
    }
    
    private func configureAddCreateView() {
        self.addLockView = AddLockView()
        addLockView.onCreateLock = onCreateLock
        self.view.addSubview(addLockView)
        addLockView.translatesAutoresizingMaskIntoConstraints = false
        addLockView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        addLockView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        addLockView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        addLockView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func onCreateLock(_ dto: CreateLockRequestDTO) {
        loadingScreen.show(on: self.view)
        viewModel.createLock(dto) { [weak self] isSuccess in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if isSuccess {
                    FDAlert()
                        .createWith(title: "Lock was created", message: nil)
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
