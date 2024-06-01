//
//  UIView+Extensions.swift
//  FlashChatApp
//
//  Created by Apple M1 on 01.06.2024.
//

import UIKit

extension UIView {
    func makeShadow() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowRadius = 10
    }
}
