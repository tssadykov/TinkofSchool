//
//  ConversationList.swift
//  TinkoffChat
//
//  Created by Тимур on 18/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import CoreData

typealias IConversationListFetcher = IConversationHandlerSetter & IFetchedResultSettuper
protocol IConversationHandlerSetter {
    func setHandler(communicationHandler: CommunicationHandler)
}

@objc protocol IFetchedResultSettuper {
    @objc optional func setupConversationsFetchedResultController() -> NSFetchedResultsController<Conversation>
    @objc optional func setupMessagesFetchedResultController(userID: String) -> NSFetchedResultsController<Message>
}

class ConversationListInteractor: IConversationListFetcher {

    var communicationManager: ICommunicationManager

    init(communicationManager: ICommunicationManager) {
        self.communicationManager = communicationManager
    }

    func setHandler(communicationHandler: CommunicationHandler) {
        communicationManager.handler = communicationHandler
    }

    func setupConversationsFetchedResultController() -> NSFetchedResultsController<Conversation> {
        let request = communicationManager.conversationRequester.fetchConversations()
        request.fetchBatchSize = 20
        let mainContext = communicationManager.coreDataStack.mainContext
        let fetchResultController = NSFetchedResultsController(fetchRequest: request,
                                                           managedObjectContext: mainContext,
                                                           sectionNameKeyPath: "isOnline",
                                                           cacheName: nil)
        return fetchResultController
    }
}
