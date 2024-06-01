//
//  ChatViewController.swift
//  FlashChatApp
//
//  Created by Apple M1 on 01.06.2024.
//

import UIKit

class ChatViewController: UIViewController {
    
    // MARK: - UI
    
    private let tableView = UITableView()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(named: Constants.BrandColors.purple)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var messageTextField: UITextField = {
        let textField = UITextField()
        
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.placeholder = Constants.enterMessagePlaceholder
        textField.textColor = UIColor(named: Constants.BrandColors.purple)
        textField.tintColor = UIColor(named: Constants.BrandColors.purple)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var enterButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(systemName: Constants.enterButtonImageName), for: .normal)
        button.tintColor = UIColor(named: Constants.BrandColors.lightPurple)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Private Properties
    
    private var messages = Message.getMessages()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        setViews()
        setupConstraints()
    }
    
    // MARK: - Set Views
    
    private func setViews() {
        title = Constants.appName
        navigationController?.navigationBar.barTintColor = UIColor(named: Constants.BrandColors.blue)
        
        view.backgroundColor = UIColor(named: Constants.BrandColors.purple)
        
        tableView.register(MessageCell.self, forCellReuseIdentifier: Constants.cellIdentfifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
        view.addSubview(containerView)
        
        containerView.addSubview(messageTextField)
        containerView.addSubview(enterButton)
        
        enterButton.addTarget(self, action: #selector(tapEnterButton), for: .touchUpInside)
    }
    
    private func setDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Actions
    
    @objc private func tapEnterButton(_ sender: UIButton) {
        if let text = messageTextField.text, !text.isEmpty {
            messages.append(Message(sender: .me, body: text))
            messageTextField.text = ""
            
            tableView.reloadData()
            
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}

extension ChatViewController {
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        setupTableViewConstraints()
        setupContainerViewConstraints()
        setupMessageTextFieldConstraints()
        setupEnterButtonConstraints()
    }
    
    private func setupTableViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupContainerViewConstraints() {
        containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(tableView.snp.bottom)
            make.height.equalTo(60)
        }
    }
    
    private func setupMessageTextFieldConstraints() {
        messageTextField.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
    }
    
    private func setupEnterButtonConstraints() {
        enterButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(messageTextField.snp.trailing).offset(20)
            make.height.width.equalTo(40)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ChatViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentfifier, for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        
        let message = messages[indexPath.row]
        cell.configure(with: message)
        cell.selectionStyle = .none
        
        return cell
    }
}
