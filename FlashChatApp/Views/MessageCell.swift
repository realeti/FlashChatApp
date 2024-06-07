//
//  MessageCell.swift
//  FlashChatApp
//
//  Created by Apple M1 on 01.06.2024.
//

import UIKit

class MessageCell: UITableViewCell {
    
    // MARK: - Elements
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fill
        stackView.contentMode = .scaleToFill
        stackView.alignment = .bottom
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var leftImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: Constants.youAvatar)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: Constants.meAvatar)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var messageView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        messageView.layoutIfNeeded()
        messageView.layer.cornerRadius = (messageView.frame.height - 20) / 4
    }
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setViews()
        setupConstraints()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Properties
    
    public func configure(with message: Message, sender: Sender) {
        switch sender {
        case .me:
            leftImageView.isHidden = true
            rightImageView.isHidden = false
            
            messageView.backgroundColor = UIColor(named: Constants.BrandColors.lightPurple)
            messageLabel.textColor = UIColor(named: Constants.BrandColors.purple)
        case .you:
            leftImageView.isHidden = false
            rightImageView.isHidden = true
            
            messageView.backgroundColor = UIColor(named: Constants.BrandColors.purple)
            messageLabel.textColor = UIColor(named: Constants.BrandColors.lightPurple)
        }
        
        messageLabel.text = message.body
    }
    
    // MARK: - Set Views
    
    private func setViews() {
        contentView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(leftImageView)
        mainStackView.addArrangedSubview(messageView)
        mainStackView.addArrangedSubview(rightImageView)
        
        messageView.addSubview(messageLabel)
    }
}

extension MessageCell {
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        setupMainStackViewConstraints()
        setupLeftImageViewConstraints()
        setupRightImageViewConstraints()
        setupMessageLabelConstraints()
    }
    
    private func setupMainStackViewConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    private func setupLeftImageViewConstraints() {
        leftImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
    }
    
    private func setupRightImageViewConstraints() {
        rightImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
    }
    
    private func setupMessageLabelConstraints() {
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
}
