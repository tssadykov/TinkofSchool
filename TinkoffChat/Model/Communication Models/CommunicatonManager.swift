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
    static let shared = CommunicationManager()
    var dataManager = GCDDataManager()
    var communicator: MultipeerCommunicator!
    var conversationHolder: [String : Conversation] = [:]
    
    
    private init() {
        dataManager.getProfile { (profile) in
            self.communicator = MultipeerCommunicator(profile: profile)
            self.communicator.delegate = self
        }
    }
    

    func didFoundUser(userId: String, userName: String?) {
        if let conversation = conversationHolder[userId] {
            conversation.online = true
        } else {
            let conversation = Conversation(userId: userId, name: userName)
            conversation.online = true
            conversationHolder[userId] = conversation
        }
        guard let delegate = delegate else { return }
        DispatchQueue.main.async {
            delegate.updateUserData()
        }
    }
    
    func didLostUser(userId: String) {
        if let conversation = conversationHolder[userId] {
            conversation.online = false
            conversationHolder.removeValue(forKey: userId)
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
        } else if let conversation = conversationHolder[toUser] {
            let message = Conversation.Message.outgoing(text)
            conversation.messageHistory.append(message)
            conversation.date = Date()
            conversation.message = text
        }
        guard let delegate = delegate else { return }
        DispatchQueue.main.async {
            delegate.updateUserData()
        }
    }
}
