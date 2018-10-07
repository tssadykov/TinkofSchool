//
//  Conversation.swift
//  TinkoffChat
//
//  Created by Тимур on 04/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

struct Conversation {
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool
    var hasUnreadMessages: Bool
    var messageHistory: [Message]
    
    enum Message {
        case incoming(String)
        case outgoing(String)
    }
}
