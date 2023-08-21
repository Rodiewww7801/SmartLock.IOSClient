//
//  UpdateUserViewController.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 19.08.2023.
//

import UIKit

class UpdateUserViewController: UIViewController {
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var topImageView: UIImageView!
    private var userIdLableTitle: UILabel!
    private var userIdLableText: UITextView!
    private var usernameLableTitle: UILabel!
    private var usernameLableText: UITextView!
    private var emailLableTitle: UILabel!
    private var emailLableText: UITextView!
    private var firstNameLabelTitle: UILabel!
    private var firstNameLabelText: UITextView!
    private var lastNameLabelTitle: UILabel!
    private var lastNameLabelText: UITextView!
    private var roleLabelTitle: UILabel!
    private var roleLabelText: UITextView!
    private var updateUserButton: UIButton!
    private var loadingScreen = FDLoadingScreen()
    private var divider: UIView!
    
    private var viewModel: UpdateUserViewModelDelegate
    
    var onUserUpdate: (()->())?
    
    init(with viewModel: UpdateUserViewModelDelegate) {
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
        updateData(viewModel.userInfo)
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
    
    func updateData(_ model: UserInfo) {
        usernameLableText.text = model.user.username
        userIdLableText.text = model.user.id
        userIdLableText.isEditable = false
        emailLableText.text = model.user.email
        firstNameLabelText.text = model.user.firstName
        lastNameLabelText.text =  model.user.lastName
        roleLabelText.text = model.user.role.rawValue
        if let photo = model.photo {
            topImageView.image = photo
        } else {
            topImageView.image = UIImage(systemName: "person.fill")
        }
    }
    
    private func configureTopImageView() {
        let image = UIImage(systemName: "person.fill")
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
        userIdLableTitle = UILabel(frame: .zero)
        userIdLableTitle.text = "Id"
        userIdLableTitle.font = UIFont.preferredFont(forTextStyle: .body)
        userIdLableTitle.numberOfLines = 0
        userIdLableTitle.textColor = .gray
        userIdLableTitle.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(userIdLableTitle)
        
        usernameLableTitle = UILabel(frame: .zero)
        usernameLableTitle.text = "Username"
        usernameLableTitle.font = UIFont.preferredFont(forTextStyle: .body)
        usernameLableTitle.numberOfLines = 0
        usernameLableTitle.textColor = .gray
        usernameLableTitle.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(usernameLableTitle)
        
        emailLableTitle = UILabel(frame: .zero)
        emailLableTitle.text = "Email"
        emailLableTitle.font = UIFont.preferredFont(forTextStyle: .body)
        emailLableTitle.numberOfLines = 0
        emailLableTitle.textColor = .gray
        emailLableTitle.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(emailLableTitle)
        
        firstNameLabelTitle = UILabel(frame: .zero)
        firstNameLabelTitle.text = "First name"
        firstNameLabelTitle.font = UIFont.preferredFont(forTextStyle: .body)
        firstNameLabelTitle.numberOfLines = 0
        firstNameLabelTitle.textColor = .gray
        firstNameLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(firstNameLabelTitle)
        
        lastNameLabelTitle = UILabel(frame: .zero)
        lastNameLabelTitle.text = "Last name"
        lastNameLabelTitle.font = UIFont.preferredFont(forTextStyle: .body)
        lastNameLabelTitle.numberOfLines = 0
        lastNameLabelTitle.textColor = .gray
        lastNameLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(lastNameLabelTitle)
        
        roleLabelTitle = UILabel(frame: .zero)
        roleLabelTitle.text = "Role"
        roleLabelTitle.font = UIFont.preferredFont(forTextStyle: .body)
        roleLabelTitle.numberOfLines = 0
        roleLabelTitle.textColor = .gray
        roleLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(roleLabelTitle)
        
        userIdLableText = UITextView(frame: .zero)
        userIdLableText.font = UIFont.preferredFont(forTextStyle: .body)
        userIdLableText.isEditable = false
        userIdLableText.textColor = .black
        userIdLableText.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(userIdLableText)
        
        usernameLableText = UITextView(frame: .zero)
        usernameLableText.font = UIFont.preferredFont(forTextStyle: .body)
        usernameLableText.textColor = .black
        usernameLableText.backgroundColor = .systemGray6
        userIdLableText.isEditable = true
        usernameLableText.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(usernameLableText)
        
        emailLableText = UITextView(frame: .zero)
        emailLableText.font = UIFont.preferredFont(forTextStyle: .body)
        emailLableText.textColor = .black
        emailLableText.backgroundColor = .systemGray6
        emailLableText.isEditable = true
        emailLableText.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(emailLableText)
        
        firstNameLabelText = UITextView(frame: .zero)
        firstNameLabelText.font = UIFont.preferredFont(forTextStyle: .body)
        firstNameLabelText.textColor = .black
        firstNameLabelText.backgroundColor = .systemGray6
        firstNameLabelText.isEditable = true
        firstNameLabelText.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(firstNameLabelText)
        
        lastNameLabelText = UITextView(frame: .zero)
        lastNameLabelText.font = UIFont.preferredFont(forTextStyle: .body)
        lastNameLabelText.textColor = .black
        lastNameLabelText.backgroundColor = .systemGray6
        lastNameLabelText.isEditable = true
        lastNameLabelText.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(lastNameLabelText)
        
        roleLabelText = UITextView(frame: .zero)
        roleLabelText.font = UIFont.preferredFont(forTextStyle: .body)
        roleLabelText.textColor = .black
       
        viewModel.getCurrentUser { [weak self] currentUser in
            DispatchQueue.main.async {
                if currentUser?.role == .admin {
                    self?.roleLabelText.isEditable = true
                    self?.roleLabelText.backgroundColor = .systemGray6
                } else {
                    self?.roleLabelText.isEditable = false
                    self?.roleLabelText.backgroundColor = .white
                }
            }
        }
       
        roleLabelText.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(roleLabelText)
        
        userIdLableTitle.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 10).isActive = true
        userIdLableTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        userIdLableTitle.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        
        userIdLableText.topAnchor.constraint(equalTo: userIdLableTitle.bottomAnchor, constant: 10).isActive = true
        userIdLableText.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        userIdLableText.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        userIdLableText.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        usernameLableTitle.topAnchor.constraint(equalTo: userIdLableText.bottomAnchor, constant: 10).isActive = true
        usernameLableTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        usernameLableTitle.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        
        usernameLableText.topAnchor.constraint(equalTo: usernameLableTitle.bottomAnchor, constant: 10).isActive = true
        usernameLableText.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        usernameLableText.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        usernameLableText.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        emailLableTitle.topAnchor.constraint(equalTo: usernameLableText.bottomAnchor, constant: 10).isActive = true
        emailLableTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        emailLableTitle.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        
        emailLableText.topAnchor.constraint(equalTo: emailLableTitle.bottomAnchor, constant: 10).isActive = true
        emailLableText.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        emailLableText.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        emailLableText.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        firstNameLabelTitle.topAnchor.constraint(equalTo: emailLableText.bottomAnchor, constant: 10).isActive = true
        firstNameLabelTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        firstNameLabelTitle.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        
        firstNameLabelText.topAnchor.constraint(equalTo: firstNameLabelTitle.bottomAnchor, constant: 10).isActive = true
        firstNameLabelText.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        firstNameLabelText.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        firstNameLabelText.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        lastNameLabelTitle.topAnchor.constraint(equalTo: firstNameLabelText.bottomAnchor, constant: 10).isActive = true
        lastNameLabelTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        lastNameLabelTitle.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        
        lastNameLabelText.topAnchor.constraint(equalTo: lastNameLabelTitle.bottomAnchor, constant: 10).isActive = true
        lastNameLabelText.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        lastNameLabelText.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        lastNameLabelText.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        roleLabelTitle.topAnchor.constraint(equalTo: lastNameLabelText.bottomAnchor, constant: 10).isActive = true
        roleLabelTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        roleLabelTitle.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        
        roleLabelText.topAnchor.constraint(equalTo: roleLabelTitle.bottomAnchor, constant: 10).isActive = true
        roleLabelText.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        roleLabelText.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -20).isActive = true
        roleLabelText.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
    }
    
    private func configureDivider() {
        divider = UIView()
        divider.layer.backgroundColor = UIColor.systemGray6.cgColor
        
        self.contentView.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.topAnchor.constraint(equalTo: roleLabelText.bottomAnchor, constant: 10).isActive = true
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
            let email = emailLableText.text,
            let username = usernameLableText.text,
            let firstName = firstNameLabelText.text,
            let lastName = lastNameLabelText.text,
            let role = roleLabelText.text
        else {
            return
        }
        let user = User(id: viewModel.userInfo.user.id,
                        username: username,
                        email: email,
                        firstName: firstName,
                        lastName: lastName,
                        role: User.Role(rawValue: role) ?? .user)
        loadingScreen.show(on: self.view)
        viewModel.updateUser(user) { isSuccess in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if isSuccess {
                    FDAlert()
                        .createWith(title: "User updated", message: nil)
                        .addAction(title: "Ok", style: .default, handler: {
                            self.onUserUpdate?()
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
