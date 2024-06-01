//
//  UIButton+Extensions.swift
//  FlashChatApp
//
//  Created by Apple M1 on 01.06.2024.
//

import UIKit

extension UIButton {
    convenience init(titleColor: UIColor?, backgroundColor: UIColor? = .clear) {
        self.init(type: .system)
        
        self.titleLabel?.font = .systemFont(ofSize: Constants.Size.buttonFontSize)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
