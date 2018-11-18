//
//  CommunicatorDelegate.swift
//  TinkoffChat
//
//  Created by Тимур on 25/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

protocol ICommunicationManager: class, IUserDiscover, ICommunicationFailHandler, IMessageHandler {

    var delegate: CommunicationIntegrator? { get set }
    var communicator: Communicator { get }
    var coreDataStack: CoreDataStack { get }
    var userRequester: IUserFetchRequester { get }
    var conversationRequester: IConversationFetchRequester { get }
    var messageRequester: IMessageFetchRequester { get }

    func didStartSessions()
}

protocol IUserDiscover {
    func didFoundUser(userId: String, userName: String?)
    func didLostUser(userId: String)
}

protocol ICommunicationFailHandler {
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
}

protocol IMessageHandler {
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    func sendMessage(text: String, conversationID: String, completion: @escaping MessageHandler)
}
