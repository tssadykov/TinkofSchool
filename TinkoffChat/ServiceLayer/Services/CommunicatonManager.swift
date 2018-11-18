//
//  CommunicatonManager.swift
//  TinkoffChat
//
//  Created by Тимур on 26/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation
import CoreData

class CommunicationManager: ICommunicationManager {

    weak var delegate: CommunicationIntegrator?
    var communicator: Communicator
    var coreDataStack: CoreDataStack
    var userRequester: IUserFetchRequester
    var conversationRequester: IConversationFetchRequester
    var messageRequester: IMessageFetchRequester
    init(name: String, communicator: Communicator,
         coreDataStack: CoreDataStack, userRequester: IUserFetchRequester,
         conversationRequester: IConversationFetchRequester, messageRequester: IMessageFetchRequester) {
        self.communicator = communicator
        self.userRequester = userRequester
        self.conversationRequester = conversationRequester
        self.messageRequester = messageRequester
        self.coreDataStack = coreDataStack
        self.communicator.delegate = self
        self.communicator.startCommunication(name: name)
    }

    func didStartSessions() {
        let saveContext = coreDataStack.saveContext
        saveContext.perform {
            DispatchQueue.main.sync {
                self.communicator.online = false
            }
            guard let conversations = Conversation.findOnlineConversations(in: saveContext,
                                                                           by: self.conversationRequester)
                else {
                    DispatchQueue.main.sync {
                        self.communicator.online = true
                    }
                    return
            }
            conversations.forEach { $0.isOnline = false; $0.user?.isOnline = false }
            self.coreDataStack.performSave(in: saveContext, completion: nil)
            DispatchQueue.main.sync {
                self.communicator.online = true
            }
        }
    }

    func didFoundUser(userId: String, userName: String?) {
        let saveContext = coreDataStack.saveContext
        saveContext.perform {
            autoreleasepool {
                guard let user = User.findOrInsertUser(userId: userId, in: saveContext,
                                                       by: self.userRequester) else { return }
                let conversation = Conversation.findOrInsertConversationWith(conversationId: userId,
                                                                             in: saveContext,
                                                                             by: self.conversationRequester)
                user.name = userName
                user.isOnline = true
                conversation.isOnline = true
                conversation.user = user
            }
            self.coreDataStack.performSave(in: saveContext, completion: nil)
        }
    }

    func didLostUser(userId: String) {
        let saveContext = coreDataStack.saveContext
        saveContext.perform {
            autoreleasepool {
                let conversation = Conversation.findOrInsertConversationWith(conversationId: userId,
                                                                             in: saveContext,
                                                                             by: self.conversationRequester)
                conversation.isOnline = false
                conversation.user?.isOnline = false
            }
            self.coreDataStack.performSave(in: saveContext, completion: nil)
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

    func sendMessage(text: String, conversationID: String, completion: @escaping MessageHandler) {
        communicator.sendMessage(text: text, to: conversationID, completionHandler: completion)
    }

    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        let saveContext = coreDataStack.saveContext
        saveContext.perform {
            let message: Message
            if let conversation = Conversation.findConversationWith(conversationId: fromUser,
                                                                    in: saveContext,
                                                                    by: self.conversationRequester) {
                message = Message.insertNewMessage(in: saveContext)
                message.isIncoming = true
                message.conversationId = conversation.conversationId
                message.text = text
                conversation.date = Date()
                message.date = Date()
                conversation.hasUnreadMessages = true
                conversation.addToMessageHistory(message)
                conversation.lastMessage = message
            } else if let conversation = Conversation.findConversationWith(conversationId: toUser,
                                                                           in: saveContext,
                                                                           by: self.conversationRequester) {
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
            self.coreDataStack.performSave(in: saveContext, completion: nil)
        }
    }
}
