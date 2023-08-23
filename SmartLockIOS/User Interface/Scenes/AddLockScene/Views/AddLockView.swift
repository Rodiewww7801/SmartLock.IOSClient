//
//  AddLockView.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 22.08.2023.
//

import UIKit

class AddLockView: UIView {
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var stackView: UIStackView!
    private var lockNameTextField: UITextField!
    private var descriptionTextField: UITextField!
    private var createButton: UIButton!
    
    var onCreateLock: ((CreateLockRequestDTO)->())?
    
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
        configureNameTextField()
        configureDescriptionTextField()
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
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 200).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25).isActive = true
    }
    
    private func configureNameTextField() {
        lockNameTextField = UITextField()
        lockNameTextField.placeholder = "Lock name"
        lockNameTextField.addTarget(self, action: #selector(validateTextFields), for: .touchDown)
        lockNameTextField.borderStyle = .roundedRect
        lockNameTextField.delegate = self
        lockNameTextField.textContentType = .username
        lockNameTextField.keyboardType = .emailAddress
        
        stackView.addArrangedSubview(lockNameTextField)
        lockNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lockNameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        lockNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configureDescriptionTextField() {
        descriptionTextField = UITextField()
        descriptionTextField.placeholder = "Description"
        descriptionTextField.addTarget(self, action: #selector(validateTextFields), for: .editingChanged)
        descriptionTextField.borderStyle = .roundedRect
        descriptionTextField.delegate = self
        
        stackView.addArrangedSubview(descriptionTextField)
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        descriptionTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configureCreateButton() {
        createButton = UIButton(type: .system)
        createButton.setTitle("Create", for: .normal)
        createButton.setTitleColor(.systemBlue, for: .normal)
        createButton.addTarget(self, action: #selector(creataeUser), for: .touchUpInside)
        
        stackView.addArrangedSubview(createButton)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc private func creataeUser() {
        guard let name = lockNameTextField.text,
              let description = descriptionTextField.text
        else {
            return
        }
        let createLockDTO = CreateLockRequestDTO(name: name, description: description)
        self.onCreateLock?(createLockDTO)
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

extension AddLockView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        textField.resignFirstResponder()
        return true;
    }
}
