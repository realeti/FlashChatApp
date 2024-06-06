//
//  Message.swift
//  FlashChatApp
//
//  Created by Apple M1 on 01.06.2024.
//

import Foundation

enum Sender {
    case me, you
}

struct Message {
    let sender: String
    let body: String
}
