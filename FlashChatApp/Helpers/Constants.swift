//
//  Constants.swift
//  FlashChatApp
//
//  Created by Apple M1 on 31.05.2024.
//

import Foundation

struct Constants {
    static let appName = "⚡FlashChat"
    static let logInName = "Log In"
    static let registerName = "Register"
    static let emailName = "Email"
    static let passwordName = "Password"
    
    static let cellIdentfifier = "MessageCell"
    static let textFieldImageName = "textField"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lightBlue = "BrandLightBlue"
    }
    
    struct Size {
        static let buttonSize: CGFloat = 48.0
        static let buttonOffset: CGFloat = 8.0
        static let buttonFontSize: CGFloat = 30.0
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dataField = "date"
    }
    
    private init() {}
}
