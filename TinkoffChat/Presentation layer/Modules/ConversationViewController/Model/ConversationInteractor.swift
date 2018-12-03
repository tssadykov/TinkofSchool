//
//  ConversationListIntercator.swift
//  TinkoffChat
//
//  Created by Тимур on 18/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import CoreData

typealias IConversationInteractor = IMessageSender & IFetchedResultSettuper
    & IConversationHandlerSetter & IConversationUpdaterSetter
protocol IMessageSender {
    func sendMessage(text: String, conversationId: String, completion: @escaping MessageHandler)
}

protocol IConversationUpdaterSetter {
    func setUpdater(communicationUpdater: CommunicationUpdater)
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

    func setHandler(communicationHandler: CommunicationHandler) {
        communicationManager.handler = communicationHandler
    }

    func setUpdater(communicationUpdater: CommunicationUpdater) {
        communicationManager.updater = communicationUpdater
    }
}
