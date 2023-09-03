//
//  UpdateLockViewController.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 02.09.2023.
//

import Foundation
import UIKit

class UpdateLockViewController: UIViewController {
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var topImageView: UIImageView!
    private var lockIdLableTitle: UILabel!
    private var lockIdLableText: UITextView!
    private var nameLableTitle: UILabel!
    private var nameLableText: UITextView!
    private var descriptionLableTitle: UILabel!
    private var descriptionLableText: UITextView!
    private var secretKeyLabelTitle: UILabel!
    private var secretKeyLabelText: UITextView!
    private var urlConnectionLabelTitle: UILabel!
    private var urlConnectionLabelText: UITextView!
    private var updateUserButton: UIButton!
    private var loadingScreen = FDLoadingScreen()
    private var divider: UIView!
    
    private var viewModel: UpdateLockViewModel
    
    var onLockUpdate: (()->())?
    
    init(with viewModel: UpdateLockViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData(lock: viewModel.lock, secretInfo: viewModel.lockSecretInfo)
    }
    
    func configureViews() {
        configureScrollView()
        configureTopImageView()
        configureLabels()
        configureDivider()
        configureSaveButton()
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
    
    func updateData(lock: Lock, secretInfo: LockSecretInfo?) {
        nameLableText.text = lock.name
        lockIdLableText.text = lock.id
        lockIdLableText.isEditable = false
        descriptionLableText.text = lock.description
        secretKeyLabelText.text = secretInfo?.secretKey
        urlConnectionLabelText.text =  secretInfo?.urlConnection
    }
    
    private func configureTopImageView() {
        let image = UIImage(systemName: "lock")
        topImageView = UIImageView(image: image)
        topImageView.tintColor = .systemGray5
        topImageView.contentMode = .scaleAspectFit
        topImageView.layer.borderWidth = 1
        topImageView.backgroundColor = .white
        topImageView.layer.borderColor = UIColor.systemGray5.cgColor
        
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(topImageView)
        topImageView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        topImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        topImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        topImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func configureLabels() {
        lockIdLableTitle = UILabel(frame: .zero)
        lockIdLableTitle.text = "Id"
        lockIdLableTitle.font = UIFont.preferredFont(forTextStyle: .body)
        lockIdLableTitle.numberOfLines = 0
        lockIdLableTitle.textColor = .gray
        lockIdLableTitle.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(lockIdLableTitle)
        
        nameLableTitle = UILabel(frame: .zero)
        nameLableTitle.text = "Name"
        nameLableTitle.font = UIFont.preferredFont(forTextStyle: .body)
        nameLableTitle.numberOfLines = 0
        nameLableTitle.textColor = .gray
        nameLableTitle.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(nameLableTitle)
        
        descriptionLableTitle = UILabel(frame: .zero)
        descriptionLableTitle.text = "Description"
        descriptionLableTitle.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLableTitle.numberOfLines = 0
        descriptionLableTitle.textColor = .gray
        descriptionLableTitle.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(descriptionLableTitle)
        
        secretKeyLabelTitle = UILabel(frame: .zero)
        secretKeyLabelTitle.text = "Secret Key"
        secretKeyLabelTitle.font = UIFont.preferredFont(forTextStyle: .body)
        secretKeyLabelTitle.numberOfLines = 0
        secretKeyLabelTitle.textColor = .gray
        secretKeyLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(secretKeyLabelTitle)
        
        urlConnectionLabelTitle = UILabel(frame: .zero)
        urlConnectionLabelTitle.text = "URL Connection"
        urlConnectionLabelTitle.font = UIFont.preferredFont(forTextStyle: .body)
        urlConnectionLabelTitle.numberOfLines = 0
        urlConnectionLabelTitle.textColor = .gray
        urlConnectionLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(urlConnectionLabelTitle)
        
        lockIdLableText = UITextView(frame: .zero)
        lockIdLableText.font = UIFont.preferredFont(forTextStyle: .body)
        lockIdLableText.isEditable = false
        lockIdLableText.textColor = .black
        lockIdLableText.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(lockIdLableText)
        
        nameLableText = UITextView(frame: .zero)
        nameLableText.font = UIFont.preferredFont(forTextStyle: .body)
        nameLableText.textColor = .black
        nameLableText.backgroundColor = .systemGray6
        lockIdLableText.isEditable = true
        nameLableText.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(nameLableText)
        
        descriptionLableText = UITextView(frame: .zero)
        descriptionLableText.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLableText.textColor = .black
        descriptionLableText.backgroundColor = .systemGray6
        descriptionLableText.isEditable = true
        descriptionLableText.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(descriptionLableText)
        
        secretKeyLabelText = UITextView(frame: .zero)
        secretKeyLabelText.font = UIFont.preferredFont(forTextStyle: .body)
        secretKeyLabelText.textColor = .black
        if viewModel.lockSecretInfo?.secretKey == nil {
            secretKeyLabelText.isEditable = false
            secretKeyLabelText.text = " "
        } else {
            secretKeyLabelText.isEditable = true
            secretKeyLabelText.backgroundColor = .systemGray6
        }
        secretKeyLabelText.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(secretKeyLabelText)
        
        urlConnectionLabelText = UITextView(frame: .zero)
        urlConnectionLabelText.font = UIFont.preferredFont(forTextStyle: .body)
        urlConnectionLabelText.textColor = .black
        urlConnectionLabelText.backgroundColor = .systemGray6
        urlConnectionLabelText.isEditable = true
        urlConnectionLabelText.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(urlConnectionLabelText)
        
        lockIdLableTitle.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 10).isActive = true
        lockIdLableTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        lockIdLableTitle.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        
        lockIdLableText.topAnchor.constraint(equalTo: lockIdLableTitle.bottomAnchor, constant: 10).isActive = true
        lockIdLableText.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        lockIdLableText.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        lockIdLableText.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        nameLableTitle.topAnchor.constraint(equalTo: lockIdLableText.bottomAnchor, constant: 10).isActive = true
        nameLableTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        nameLableTitle.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        
        nameLableText.topAnchor.constraint(equalTo: nameLableTitle.bottomAnchor, constant: 10).isActive = true
        nameLableText.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        nameLableText.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        nameLableText.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        descriptionLableTitle.topAnchor.constraint(equalTo: nameLableText.bottomAnchor, constant: 10).isActive = true
        descriptionLableTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        descriptionLableTitle.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        
        descriptionLableText.topAnchor.constraint(equalTo: descriptionLableTitle.bottomAnchor, constant: 10).isActive = true
        descriptionLableText.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        descriptionLableText.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        descriptionLableText.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        secretKeyLabelTitle.topAnchor.constraint(equalTo: descriptionLableText.bottomAnchor, constant: 10).isActive = true
        secretKeyLabelTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        secretKeyLabelTitle.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        
        secretKeyLabelText.topAnchor.constraint(equalTo: secretKeyLabelTitle.bottomAnchor, constant: 10).isActive = true
        secretKeyLabelText.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        secretKeyLabelText.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        secretKeyLabelText.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        urlConnectionLabelTitle.topAnchor.constraint(equalTo: secretKeyLabelText.bottomAnchor, constant: 10).isActive = true
        urlConnectionLabelTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        urlConnectionLabelTitle.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        
        urlConnectionLabelText.topAnchor.constraint(equalTo: urlConnectionLabelTitle.bottomAnchor, constant: 10).isActive = true
        urlConnectionLabelText.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        urlConnectionLabelText.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        urlConnectionLabelText.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
    }
    
    private func configureDivider() {
        divider = UIView()
        divider.layer.backgroundColor = UIColor.systemGray6.cgColor
        
        self.contentView.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.topAnchor.constraint(equalTo: urlConnectionLabelText.bottomAnchor, constant: 10).isActive = true
        divider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 20).isActive = true
    }
    
    private func configureSaveButton() {
        updateUserButton = UIButton(type: .system)
        updateUserButton.setTitle("Update", for: .normal)
        updateUserButton.setTitleColor(.systemBlue, for: .normal)
        updateUserButton.addTarget(self, action: #selector(updateUser), for: .touchUpInside)
        
        self.contentView.addSubview(updateUserButton)
        updateUserButton.translatesAutoresizingMaskIntoConstraints = false
        updateUserButton.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 2).isActive = true
        updateUserButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 20).isActive = true
        updateUserButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        updateUserButton.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    @objc private func updateUser() {
        guard
            let description = descriptionLableText.text,
            let name = nameLableText.text,
            let secretKey = secretKeyLabelText.text,
            let urlConnection = urlConnectionLabelText.text
        else {
            return
        }
        
        let lock = Lock(id: viewModel.lock.id, name: name, description: description)
        let lockSecretInfo = LockSecretInfo(secretKey: secretKey, urlConnection: urlConnection)
        loadingScreen.show(on: self.view)
        viewModel.updateLock(lock, lockSecretInfo) { [weak self] isSuccess in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if isSuccess {
                    FDAlert()
                        .createWith(title: "Lock updated", message: nil)
                        .addAction(title: "Ok", style: .default, handler: {
                            self.onLockUpdate?()
                        })
                        .present(on: self)
                }
                self.loadingScreen.stop()
            }
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}
