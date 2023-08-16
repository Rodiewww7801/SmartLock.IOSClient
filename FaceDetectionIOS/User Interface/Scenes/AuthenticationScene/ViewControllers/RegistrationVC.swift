//
//  RegistrationVC.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.08.2023.
//

import Foundation
import UIKit

class RegistrationVC: UIViewController {
    private var stackView: UIStackView!
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    private var confirmPasswordTextField: UITextField!
    private var passwordTextFieldRightStackView: UIStackView!
    private var generatePasswordButton: UIButton!
    private var secureVisibilityButton: UIButton!
    private var secureVisibilityButton2: UIButton!
    private var firstNameTextField: UITextField!
    private var lastNameTextField: UITextField!
    private var registerButton: UIButton!
    private var isValidEmail: Bool = false
    private var isValidPassword: Bool = false
    private var registrationViewModel: RegistrationViewModelDelegate
    private var loadingScreen = FDLoadingScreen()
    var onRegisterAction: (()->())?
    
    init(with delegate: RegistrationViewModelDelegate) {
        self.registrationViewModel = delegate
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
        self.view.layer.backgroundColor = UIColor.white.cgColor
        
        configureStackView()
        configureEmailTextField()
        configurePasswordTextField()
        configureConfirmPasswordTextField()
        configurePasswordTextFieldRightStackView()
        configureGeneratePasswordButton()
        configureSecureVisibilityButton()
        configureSecureVisibilityButton2()
        configureFirstNameTextField()
        configureLastNameTextField()
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
        emailTextField.addTarget(self, action: #selector(validateTextFields), for: .editingChanged)
        emailTextField.borderStyle = .roundedRect
        emailTextField.delegate = self
        emailTextField.textContentType = .username
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
        passwordTextField.delegate = self
        passwordTextField.textContentType = .newPassword
        
        stackView.addArrangedSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configureConfirmPasswordTextField() {
        confirmPasswordTextField = UITextField()
        confirmPasswordTextField.placeholder = "Confirm password"
        confirmPasswordTextField.addTarget(self, action: #selector(validateTextFields), for: .editingChanged)
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.delegate = self
        passwordTextField.textContentType = .newPassword
        
        stackView.addArrangedSubview(confirmPasswordTextField)
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configurePasswordTextFieldRightStackView() {
        passwordTextFieldRightStackView = UIStackView()
        passwordTextFieldRightStackView.axis = .horizontal
        passwordTextFieldRightStackView.spacing = 0
        
        passwordTextField.rightView = passwordTextFieldRightStackView
        passwordTextField.rightViewMode = .always
        
        passwordTextField.addSubview(passwordTextFieldRightStackView)
        
        passwordTextFieldRightStackView.translatesAutoresizingMaskIntoConstraints = false
        passwordTextFieldRightStackView.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor).isActive = true
        passwordTextFieldRightStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        passwordTextFieldRightStackView.topAnchor.constraint(equalTo: passwordTextField.topAnchor).isActive = true
    }
    
    private func configureSecureVisibilityButton() {
        secureVisibilityButton = UIButton(type: .custom)
        let eyeImage = UIImage(systemName: "eye")
        secureVisibilityButton.setImage(eyeImage, for: .normal)
        secureVisibilityButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        secureVisibilityButton.imageView?.tintColor = .gray
        
        passwordTextFieldRightStackView.addArrangedSubview(secureVisibilityButton)
        secureVisibilityButton.translatesAutoresizingMaskIntoConstraints = false
        secureVisibilityButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        secureVisibilityButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configureGeneratePasswordButton() {
        generatePasswordButton = UIButton(type: .custom)
        let keyImage = UIImage(systemName: "key")
        generatePasswordButton.setImage(keyImage, for: .normal)
        generatePasswordButton.addTarget(self, action: #selector(generatePassword), for: .touchUpInside)
        generatePasswordButton.imageView?.tintColor = .gray
        
        passwordTextFieldRightStackView.addArrangedSubview(generatePasswordButton)

        generatePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        generatePasswordButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        generatePasswordButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configureSecureVisibilityButton2() {
        secureVisibilityButton2 = UIButton(type: .custom)
        let eyeImage = UIImage(systemName: "eye")
        secureVisibilityButton2.setImage(eyeImage, for: .normal)
        secureVisibilityButton2.addTarget(self, action: #selector(showPasswordForConfirm), for: .touchUpInside)
        secureVisibilityButton2.imageView?.tintColor = .gray
        confirmPasswordTextField.rightView = secureVisibilityButton2
        confirmPasswordTextField.rightViewMode = .always
        
        passwordTextField.addSubview(secureVisibilityButton2)

        secureVisibilityButton2.translatesAutoresizingMaskIntoConstraints = false
        secureVisibilityButton2.trailingAnchor.constraint(equalTo: confirmPasswordTextField.trailingAnchor).isActive = true
        secureVisibilityButton2.widthAnchor.constraint(equalToConstant: 40).isActive = true
        secureVisibilityButton2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        secureVisibilityButton2.topAnchor.constraint(equalTo: passwordTextField.topAnchor).isActive = true
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
    
    private func configureRegisterButton() {
        registerButton = UIButton(type: .system)
        registerButton.setTitle("Register", for: .normal)
        registerButton.isEnabled = false
        registerButton.setTitleColor(.gray, for: .normal)
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
    
    @objc private func showPasswordForConfirm() {
        let secureState = confirmPasswordTextField.isSecureTextEntry
        if !secureState {
            let eyeImage = UIImage(systemName: "eye")
            secureVisibilityButton2.setImage(eyeImage, for: .normal)
        } else {
            let eyeSlashImage = UIImage(systemName: "eye.slash")
            secureVisibilityButton2.setImage(eyeSlashImage, for: .normal)
        }
        confirmPasswordTextField.isSecureTextEntry.toggle()
    }
    
    @objc private func generatePassword() {
        let passwordCharacters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890")
        let passwordSymbols = Array("!@#$%^&*().,?){}[]:'|")
        let generatedPassword = String((0..<30).compactMap{ number in
            if number % 3 == 0, number != 0 {
                return passwordSymbols.randomElement()
            } else {
                return passwordCharacters.randomElement()
            }
        })
        passwordTextField.text = generatedPassword
        confirmPasswordTextField.text = generatedPassword

        let eyeSlashImage = UIImage(systemName: "eye.slash")
        secureVisibilityButton.setImage(eyeSlashImage, for: .normal)
        secureVisibilityButton2.setImage(eyeSlashImage, for: .normal)
        passwordTextField.isSecureTextEntry = false
        confirmPasswordTextField.isSecureTextEntry = false
        
        if let passwordTextField = passwordTextField {
            validateTextFields(passwordTextField)
        }
    }
    
    @objc private func register() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text,
              let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text
        else {
            return
        }
        let registerModel = RegisterRequestDTO(email: email,
                                          password: password,
                                          confirmPassword: confirmPassword,
                                          firstName: firstName,
                                          lastName: lastName)
        loadingScreen.show(on: self.view)
        registrationViewModel.onRegister(registerModel) { [weak self] isSuccess, error in
            DispatchQueue.main.async {
                self?.loadingScreen.stop()
                if isSuccess {
                    FDAlert()
                        .createWith(title: "You are register successfully", message: nil)
                        .addAction(title: "Login", style: .default, handler: { [weak self] in
                            self?.onRegisterAction?()
                        })
                        .present(on: self)
                }
            }
        }
    }
    
    @objc private func validateTextFields(_ sender: Any) {
        let textField = sender as? UITextField
        if textField == self.emailTextField {
            self.isValidEmail = RegexValidator.isValidEmail(emailTextField.text ?? "")
        }
        
        if passwordTextField.text == confirmPasswordTextField.text, lastNameTextField.text?.isEmpty == false, firstNameTextField.text?.isEmpty == false {
            self.isValidPassword = true
        } else {
            self.isValidPassword = false
        }
        
        if isValidEmail, isValidPassword {
            registerButton.isEnabled = true
            registerButton.setTitleColor(.systemBlue, for: .normal)
        } else {
            registerButton.isEnabled = false
            registerButton.setTitleColor(.gray, for: .normal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension RegistrationVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return true;
    }
}
