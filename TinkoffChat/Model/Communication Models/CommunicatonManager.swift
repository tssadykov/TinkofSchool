//
//  CommunicatonManager.swift
//  TinkoffChat
//
//  Created by Тимур on 26/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

class CommunicationManager: CommunicatorDelegate {
    
    weak var delegate: CommunicationIntegrate?
    
    let shared = CommunicationManager()
    var dataManager = GCDDataManager()
    private var communicator: MultipeerCommunicator!
    private init() {
        dataManager.getProfile { (profile) in
            self.communicator = MultipeerCommunicator(profile: profile)
        }
    }
    var conversationHolder: [String : Conversation] = [:]
    

    func didFoundUser(userId: String, userName: String?) {
        let conversation = Conversation(name: userName)
        conversation.online = true
        conversationHolder[userId] = conversation
        guard let delegate = delegate else { return }
        DispatchQueue.main.async {
            delegate.updateUserData()
        }
    }
    
    func didLostUser(userId: String) {
        if let conversation = conversationHolder[userId] {
            conversation.online = false
        }
        guard let delegate = delegate else { return }
        DispatchQueue.main.async {
            delegate.updateUserData()
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        guard let delegate = delegate else { return }
        DispatchQueue.main.async {
            delegate.handleError(error: error)
        }
    }
    
    func failedToStartAdvertising(error: Error) {
        guard let delegate = delegate else { return }
        DispatchQueue.main.async {
            delegate.handleError(error: error)
        }
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        if let conversation = conversationHolder[fromUser] {
            let message = Conversation.Message.incoming(text)
            conversation.messageHistory.append(message)
            conversation.date = Date()
            conversation.message = text
            conversation.hasUnreadMessages = true
        }
        guard let delegate = delegate else { return }
        DispatchQueue.main.async {
            delegate.updateUserData()
        }
    }
}
