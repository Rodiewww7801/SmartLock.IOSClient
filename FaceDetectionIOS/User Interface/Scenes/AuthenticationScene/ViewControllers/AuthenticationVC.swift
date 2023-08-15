//
//  AuthenticationVC.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 13.08.2023.
//

import Foundation
import UIKit

class AuthenticationVC: UIViewController {
    private var stackView: UIStackView!
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    private var secureVisibilityButton: UIButton!
    private var loginButton: UIButton!
    private var divider: UIView!
    private var registerButton: UIButton!
    private var isValidEmail: Bool = false
    private var isValidPassword: Bool = false
    private var viewModelDelegate: AuthenticationViewModelDelegate
    private var loadingScreen = FDLoadingScreen()
    
    var onLoginAction: (()->())?
    var onRegisterAction: (()->())?
    
    init(with viewModel: AuthenticationViewModelDelegate) {
        self.viewModelDelegate = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        configureViews()
    }
    
    private func configureViews() {
        configureStackView()
        configureEmailTextField()
        configurePasswordTextField()
        configureSecureVisibilityButton()
        configureLoginButton()
        configureDivider()
        configureRegisterButton()
    }
    
    private func configureStackView() {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
    }
    
    private func configureEmailTextField() {
        emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.addTarget(self, action: #selector(validateTextFields), for: .editingChanged)
        emailTextField.textContentType = .emailAddress
        emailTextField.keyboardType = .emailAddress
        
        stackView.addArrangedSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configurePasswordTextField() {
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.addTarget(self, action: #selector(validateTextFields), for: .editingChanged)
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .password
        
        
        stackView.addArrangedSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configureSecureVisibilityButton() {
        secureVisibilityButton = UIButton(type: .custom)
        let eyeImage = UIImage(systemName: "eye")
        secureVisibilityButton.setImage(eyeImage, for: .normal)
        secureVisibilityButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        secureVisibilityButton.imageView?.tintColor = .gray
        passwordTextField.rightView = secureVisibilityButton
        passwordTextField.rightViewMode = .always
        
        passwordTextField.addSubview(secureVisibilityButton)

        secureVisibilityButton.translatesAutoresizingMaskIntoConstraints = false
        secureVisibilityButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor).isActive = true
        secureVisibilityButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        secureVisibilityButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        secureVisibilityButton.topAnchor.constraint(equalTo: passwordTextField.topAnchor).isActive = true
    }
    
    private func configureLoginButton() {
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.gray, for: .normal)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        stackView.addArrangedSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configureDivider() {
        divider = UIView()
        divider.layer.backgroundColor = UIColor.systemGray6.cgColor
        
        stackView.addArrangedSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }
    
    private func configureRegisterButton() {
        registerButton = UIButton(type: .system)
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.systemBlue, for: .normal)
        registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        stackView.addArrangedSubview(registerButton)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc private func showPassword() {
        let secureState = passwordTextField.isSecureTextEntry
        if !secureState {
            let eyeImage = UIImage(systemName: "eye")
            secureVisibilityButton.setImage(eyeImage, for: .normal)
        } else {
            let eyeSlashImage = UIImage(systemName: "eye.slash")
            secureVisibilityButton.setImage(eyeSlashImage, for: .normal)
        }
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @objc private func login() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            loadingScreen.show(on: self.view)
            viewModelDelegate.onLogin(email, password: password) { [weak self] isSuccess, error in
                DispatchQueue.main.async {
                    self?.loadingScreen.stop()
                    if isSuccess {
                        DispatchQueue.main.async {
                            self?.onLoginAction?()
                        }
                    } else {
                        FDAlert()
                            .createWith(title: "Sorry, error", message: "\(String(describing: error))")
                            .addAction(title: "Try again", style: .default, handler: nil)
                            .present(on: self)
                    }
                }
            }
        }
    }
    
    @objc private func register() {
        onRegisterAction?()
    }
    
    @objc private func validateTextFields(_ sender: Any) {
        let textField = sender as? UITextField
        if textField == self.emailTextField {
            self.isValidEmail = RegexValidator.isValidEmail(emailTextField.text ?? "")
        }
        
        if textField == self.passwordTextField {
            if textField?.text?.count ?? 0 > 6 {
                self.isValidPassword = true
            } else {
                self.isValidPassword = false
            }
        }
        
        if isValidEmail, isValidPassword {
            loginButton.isEnabled = true
            loginButton.setTitleColor(.systemBlue, for: .normal)
        } else {
            loginButton.isEnabled = false
            loginButton.setTitleColor(.gray, for: .normal)
        }
    }
}
