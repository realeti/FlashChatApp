//
//  WelcomeViewController.swift
//  FlashChatApp
//
//  Created by Apple M1 on 31.05.2024.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor(named: Constants.BrandColors.blue)
        label.font = .systemFont(ofSize: 50.0, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let registerButton = UIButton(
        titleColor: UIColor(named: Constants.BrandColors.blue),
        backgroundColor: UIColor(named: Constants.BrandColors.lightBlue)
    )
    
    private let loginButton = UIButton(
        titleColor: .white,
        backgroundColor: .systemTeal
    )
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        setupConstraints()
        animationText()
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Set Views
    
    private func setViews() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .systemYellow
        
        view.addSubview(titleLabel)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        
        loginButton.setTitle(Constants.logInName, for: .normal)
        registerButton.setTitle(Constants.registerName, for: .normal)
        
        registerButton.addTarget(self, action: #selector(buttonsTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(buttonsTapped), for: .touchUpInside)
    }
    
    private func animationText() {
        let titleText = Constants.appName
        titleLabel.text = ""
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 19.0, weight: .black),
            .foregroundColor: UIColor.white
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attributes
        
        for letter in titleText.enumerated() {
            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(letter.offset), repeats: false) { _ in
                self.titleLabel.text?.append(letter.element)
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func buttonsTapped(_ sender: UIButton) {
        let registerVC = RegisterViewController()
        
        if sender.currentTitle == Constants.registerName {
            registerVC.authorizationType = .register
        } else if sender.currentTitle == Constants.logInName {
            registerVC.authorizationType = .logIn
        }
        
        navigationController?.pushViewController(registerVC, animated: true)
    }
}

extension WelcomeViewController {
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        setupTitleLabelConstraints()
        setupLogInButtonConstraints()
        setupRegisterButtonConstraints()
    }
    
    private func setupTitleLabelConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupLogInButtonConstraints() {
        loginButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.Size.buttonSize)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupRegisterButtonConstraints() {
        registerButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(loginButton.snp.top).offset(-Constants.Size.buttonOffset)
        }
    }
}
