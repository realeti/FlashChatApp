//
//  UITextField+Extensions.swift
//  FlashChatApp
//
//  Created by Apple M1 on 01.06.2024.
//

import UIKit

extension UITextField {
    convenience init(placeholder: String, color: UIColor?, contentType: UITextContentType?, keyboardType: UIKeyboardType = .default) {
        self.init()
        
        self.placeholder = placeholder
        self.textAlignment = .center
        self.backgroundColor = .white
        self.layer.cornerRadius = Constants.Size.textFieldCornerRadius
        self.font = .systemFont(ofSize: 25.0)
        self.textColor = color
        self.tintColor = color
        self.textContentType = contentType
        self.keyboardType = keyboardType
    }
}
