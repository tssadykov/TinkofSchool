//
//  Conversation.swift
//  TinkoffChat
//
//  Created by Тимур on 04/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

class Conversation {
    var name: String?
    var message: String?
    var date: Date?
    var userId: String
    var online: Bool
    var hasUnreadMessages: Bool
    var messageHistory: [Message] = []
    
    init(userId: String, name: String?) {
        self.userId = userId
        self.name = name
        online = true
        hasUnreadMessages = false
    }
    
    enum Message {
        case incoming(String)
        case outgoing(String)
    }
}
