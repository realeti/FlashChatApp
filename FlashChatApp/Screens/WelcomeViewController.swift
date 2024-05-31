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
     }
    
    // MARK: - Set Views
    
    private func setViews() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        
        titleLabel.text = Constants.appName
        loginButton.setTitle(Constants.logInName, for: .normal)
        registerButton.setTitle(Constants.registerName, for: .normal)
        
        registerButton.addTarget(self, action: #selector(buttonsTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(buttonsTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func buttonsTapped(_ sender: UIButton) {
        let registerVC = RegisterViewController()
        
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

extension UIButton {
    convenience init(titleColor: UIColor?, backgroundColor: UIColor? = .clear) {
        self.init(type: .system)
        
        self.titleLabel?.font = .systemFont(ofSize: Constants.Size.buttonFontSize)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
