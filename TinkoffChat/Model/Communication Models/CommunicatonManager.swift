//
//  CommunicatonManager.swift
//  TinkoffChat
//
//  Created by Тимур on 26/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation
import CoreData

class CommunicationManager: CommunicatorDelegate {

    weak var delegate: CommunicationIntegrator?
    static let shared = CommunicationManager()
    var storageManager = StorageManager()
    var communicator: MultipeerCommunicator?

    private init() {
        storageManager.getProfile { (profile) in
            self.communicator = MultipeerCommunicator(profile: profile)
            self.communicator?.delegate = self
        }
    }

    func didStartSessions() {
        let saveContext = CoreDataStack.shared.saveContext
        saveContext.perform {
            DispatchQueue.main.sync {
                self.communicator?.online = false
            }
            guard let conversations = Conversation.findOnlineConversations(in: saveContext)
                else {
                    DispatchQueue.main.sync {
                        self.communicator?.online = true
                    }
                    return
            }
            conversations.forEach { $0.isOnline = false; $0.user?.isOnline = false }
            CoreDataStack.shared.performSave(in: saveContext, completion: nil)
            DispatchQueue.main.sync {
                self.communicator?.online = true
            }
        }
    }

    func didFoundUser(userId: String, userName: String?) {
        let saveContext = CoreDataStack.shared.saveContext
        saveContext.perform {
            autoreleasepool {
                guard let user = User.findOrInsertUser(userId: userId, in: saveContext) else { return }
                let conversation = Conversation.findOrInsertConversationWith(conversationId: userId, in: saveContext)
                user.name = userName
                user.isOnline = true
                conversation.isOnline = true
                conversation.user = user
            }
            CoreDataStack.shared.performSave(in: saveContext, completion: nil)
        }
    }

    func didLostUser(userId: String) {
        let saveContext = CoreDataStack.shared.saveContext
        saveContext.perform {
            autoreleasepool {
                let conversation = Conversation.findOrInsertConversationWith(conversationId: userId, in: saveContext)
                conversation.isOnline = false
                conversation.user?.isOnline = false
            }
            CoreDataStack.shared.performSave(in: saveContext, completion: nil)
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
        let saveContext = CoreDataStack.shared.saveContext
        saveContext.perform {
            let message: Message
            if let conversation = Conversation.findConversationWith(conversationId: fromUser, in: saveContext) {
                message = Message.insertNewMessage(in: saveContext)
                message.isIncoming = true
                message.conversationId = conversation.conversationId
                message.text = text
                conversation.date = Date()
                message.date = Date()
                conversation.hasUnreadMessages = true
                conversation.addToMessageHistory(message)
                conversation.lastMessage = message
            } else if let conversation = Conversation.findConversationWith(conversationId: toUser, in: saveContext) {
                message = Message.insertNewMessage(in: saveContext)
                message.isIncoming = false
                message.conversationId = conversation.conversationId
                message.text = text
                conversation.date = Date()
                message.date = Date()
                conversation.hasUnreadMessages = false
                conversation.addToMessageHistory(message)
                conversation.lastMessage = message
            }
            CoreDataStack.shared.performSave(in: saveContext, completion: nil)
        }
    }
}
