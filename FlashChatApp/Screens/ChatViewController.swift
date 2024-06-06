//
//  ChatViewController.swift
//  FlashChatApp
//
//  Created by Apple M1 on 01.06.2024.
//

import UIKit
import Firebase

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
    
    private lazy var logOutButton = UIBarButtonItem(title: Constants.logout, style: .plain, target: self, action: #selector(logOutPressed))
    
    // MARK: - Private Properties
    
    private var messages: [Message] = []
    private let db =  Firestore.firestore()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        setViews()
        setupConstraints()
        
        loadMessages()
    }
    
    // MARK: - Set Views
    
    private func setViews() {
        title = Constants.appName
        view.backgroundColor = UIColor(named: Constants.BrandColors.purple)
        
        navigationController?.navigationBar.barTintColor = UIColor(named: Constants.BrandColors.blue)
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = logOutButton
        logOutButton.tintColor = .systemRed
        
        tableView.register(MessageCell.self, forCellReuseIdentifier: Constants.cellIdentfifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
        view.addSubview(containerView)
        
        containerView.addSubview(messageTextField)
        containerView.addSubview(enterButton)
        
        enterButton.addTarget(self, action: #selector(tapEnterButton), for: .touchUpInside)
    }
    
    // MARK: - Set delegates
    
    private func setDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Load messages
    
    private func loadMessages() {
        db.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dataField)
            .addSnapshotListener { (querySnapshot, error) in
                
            if let error {
                print("There was an issue retrieving data from Firestore. \(error.localizedDescription)")
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {
                    return
                }
                
                self.messages = []
                
                snapshotDocuments.forEach { document in
                    let data = document.data()
                    
                    guard let sender = data[Constants.FStore.senderField] as? String,
                          let messageBody = data[Constants.FStore.bodyField] as? String else {
                        return
                    }
                    
                    let newMessage = Message(sender: sender, body: messageBody)
                    self.messages.append(newMessage)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        
                        let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func tapEnterButton(_ sender: UIButton) {
        guard let messageBody = messageTextField.text,
              let messageSender = Auth.auth().currentUser?.email,
              !messageBody.isEmpty else {
            return
        }
        
        db.collection(Constants.FStore.collectionName).addDocument(data: [
            Constants.FStore.senderField: messageSender,
            Constants.FStore.bodyField: messageBody,
            Constants.FStore.dataField: Date().timeIntervalSince1970
        ]) { error in
            if let error {
                print("There was an issue saving data to firestore, \(error.localizedDescription)")
            } else {
                print("Successfully saved data.")
                
                DispatchQueue.main.async {
                    self.messageTextField.text = ""
                }
            }
        }
    }
    
    @objc private func logOutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            showAlert(message: signOutError.localizedDescription)
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: Constants.alertError, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.alertOk, style: .default))
        
        present(alert, animated: true)
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
        let sender: Sender = message.sender == Auth.auth().currentUser?.email ? .me: .you
        
        cell.configure(with: message, sender: sender)
        cell.selectionStyle = .none
        
        return cell
    }
}
