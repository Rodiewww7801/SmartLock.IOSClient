//
//  UserCreateView.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import UIKit

class UserCreateView: UIView {
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var stackView: UIStackView!
    private var topImageView: UIImageView!
    private var emailTextField: UITextField!
    private var firstNameTextField: UITextField!
    private var lastNameTextField: UITextField!
    private var roleTextField: UITextField!
    private var createUserButton: UIButton!
    
    var onCreateAction: ((CreateUserRequestDTO)->())?
    
    init() {
        super.init(frame: .zero)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        configureViews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        self.layer.backgroundColor = UIColor.white.cgColor
        
        configureScrollView()
        configureStackView()
        configureTopImageView()
        configureEmailTextField()
        configureFirstNameTextField()
        configureLastNameTextField()
        configureRoleTextField()
        configureCreateButton()
    }
    
    private func configureScrollView() {
        scrollView = UIScrollView()
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero

        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: -100).isActive = true
    }
    
    private func configureStackView() {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25).isActive = true
    }
    
    private func configureTopImageView() {
        let imageContainer = UIView()
        let image = UIImage(systemName: "person.fill")
        topImageView = UIImageView(image: image)
        topImageView.tintColor = .systemGray5
        topImageView.contentMode = .scaleAspectFit
        topImageView.layer.borderWidth = 1
        topImageView.backgroundColor = .white
        topImageView.layer.borderColor = UIColor.systemGray5.cgColor
        
        stackView.addArrangedSubview(imageContainer)
        imageContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageContainer.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        imageContainer.addSubview(topImageView)
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        topImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        topImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        topImageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor).isActive = true
        topImageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor).isActive = true
    }
    
    private func configureEmailTextField() {
        emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.addTarget(self, action: #selector(validateTextFields), for: .touchDown)
        emailTextField.borderStyle = .roundedRect
        emailTextField.delegate = self
        emailTextField.textContentType = .username
        emailTextField.keyboardType = .emailAddress
        
        stackView.addArrangedSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configureFirstNameTextField() {
        firstNameTextField = UITextField()
        firstNameTextField.placeholder = "First name"
        firstNameTextField.addTarget(self, action: #selector(validateTextFields), for: .editingChanged)
        firstNameTextField.borderStyle = .roundedRect
        firstNameTextField.delegate = self
        
        stackView.addArrangedSubview(firstNameTextField)
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        firstNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configureLastNameTextField() {
        lastNameTextField = UITextField()
        lastNameTextField.placeholder = "Last name"
        lastNameTextField.addTarget(self, action: #selector(validateTextFields), for: .editingChanged)
        lastNameTextField.borderStyle = .roundedRect
        lastNameTextField.delegate = self
        
        stackView.addArrangedSubview(lastNameTextField)
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        lastNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configureRoleTextField() {
        roleTextField = UITextField()
        roleTextField.placeholder = "Role"
        roleTextField.addTarget(self, action: #selector(validateTextFields), for: .editingChanged)
        roleTextField.borderStyle = .roundedRect
        roleTextField.delegate = self
        
        stackView.addArrangedSubview(roleTextField)
        roleTextField.translatesAutoresizingMaskIntoConstraints = false
        roleTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        roleTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configureCreateButton() {
        createUserButton = UIButton(type: .system)
        createUserButton.setTitle("Create", for: .normal)
        createUserButton.setTitleColor(.systemBlue, for: .normal)
        createUserButton.addTarget(self, action: #selector(creataeUser), for: .touchUpInside)
        
        stackView.addArrangedSubview(createUserButton)
        createUserButton.translatesAutoresizingMaskIntoConstraints = false
        createUserButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc private func creataeUser() {
        guard let email = emailTextField.text,
              let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let role = roleTextField.text
        else {
            return
        }
        let createUserDTO = CreateUserRequestDTO(email: email, firstName: firstName, lastName: lastName, status: role)
        self.onCreateAction?(createUserDTO)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    @objc private func validateTextFields(_ sender: Any) {

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

extension UserCreateView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        textField.resignFirstResponder()
        return true;
    }
}

