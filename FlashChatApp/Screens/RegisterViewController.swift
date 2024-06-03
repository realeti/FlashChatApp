//
//  RegisterViewController.swift
//  FlashChatApp
//
//  Created by Apple M1 on 31.05.2024.
//

import UIKit
import SnapKit
import FirebaseAuth

enum AuthorizationType: String {
    case register = "Register"
    case logIn = "Log In"
}

class RegisterViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let emailTextField = UITextField(
        placeholder: Constants.emailName,
        color: UIColor(named: Constants.BrandColors.blue),
        contentType: .emailAddress,
        keyboardType: .emailAddress
    )
    
    private let passwordTextField = UITextField(
        placeholder: Constants.passwordName,
        color: .black,
        contentType: .password
    )
    
    private let registerButton = UIButton(titleColor: UIColor(named: Constants.BrandColors.blue))
    
    // MARK: - Public Properties
    
    public var authorizationType: AuthorizationType?
    
    // MARK: -  Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        setupConstraints()
    }
    
    // MARK: - Set Views
    
    private func setViews() {
        switch authorizationType {
        case .register:
            view.backgroundColor = UIColor(named: Constants.BrandColors.lightBlue)
            registerButton.setTitle(Constants.registerName, for: .normal)
        case .logIn:
            view.backgroundColor = UIColor(named: Constants.BrandColors.blue)
            registerButton.setTitle(Constants.logInName, for: .normal)
            registerButton.setTitleColor(.white, for: .normal)
            
            // for testing
            emailTextField.text = "501@bs.com"
            passwordTextField.text = "123456"
        default:
            break
        }
        
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(emailTextField)
        mainStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(registerButton)
        
        emailTextField.makeShadow()
        passwordTextField.makeShadow()
        passwordTextField.isSecureTextEntry = true
        
        registerButton.addTarget(self, action: #selector(buttonsTapped), for: .touchUpInside)
    }
    
    @objc private func buttonsTapped(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        if sender.currentTitle == Constants.logInName {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error {
                    self.showAlert(message: error.localizedDescription)
                } else {
                    self.goToChatVC()
                }
            }
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error {
                    self.showAlert(message: error.localizedDescription)
                } else {
                    self.goToChatVC()
                }
            }
        }
    }
    
    private func goToChatVC() {
        let chatVC = ChatViewController()
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: Constants.alertError, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.alertOk, style: .default))
        
        present(alert, animated: true)
    }
}

extension RegisterViewController {
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        setupMainStackViewConstraints()
        setupEmailTextFieldConstraints()
        setupPassowrdTextFieldConstraints()
    }
    
    private func setupMainStackViewConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupEmailTextFieldConstraints() {
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(60.0)
            make.leading.trailing.equalTo(view).inset(36.0)
        }
    }
    
    private func setupPassowrdTextFieldConstraints() {
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(60.0)
            make.leading.trailing.equalTo(view).inset(36.0)
        }
    }
}
