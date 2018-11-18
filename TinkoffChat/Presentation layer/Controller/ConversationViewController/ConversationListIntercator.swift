//
//  ConversationListIntercator.swift
//  TinkoffChat
//
//  Created by Тимур on 18/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import CoreData

typealias IConversationInteractor = IMessageSender & IFetchedResultSettuper
protocol IMessageSender {
    var communicationManager: ICommunicationManager { get }
    func sendMessage(text: String, conversationId: String, completion: @escaping MessageHandler)
}

class ConversationInteractor: IConversationInteractor {
    var communicationManager: ICommunicationManager

    init(communicationManager: ICommunicationManager) {
        self.communicationManager = communicationManager
    }

    func sendMessage(text: String, conversationId: String, completion: @escaping MessageHandler) {
        communicationManager.sendMessage(text: text, conversationID: conversationId, completion: completion)
    }

    func setupMessagesFetchedResultController(userID: String) -> NSFetchedResultsController<Message> {
        let request = communicationManager.messageRequester.fetchMessagesFrom(conversationId: userID)
        request.fetchBatchSize = 20
        let mainContext = communicationManager.coreDataStack.mainContext
        let fetchResultController = NSFetchedResultsController(fetchRequest: request,
                                                           managedObjectContext: mainContext,
                                                           sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }
}
