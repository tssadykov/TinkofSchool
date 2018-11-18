//
//  ConversationFetchRequest.swift
//  TinkoffChat
//
//  Created by Тимур on 17/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import CoreData

protocol IConversationFetchRequester {
    func fetchConversations() -> NSFetchRequest<Conversation>
    func fetchOnlineConversations() -> NSFetchRequest<Conversation>
    func fetchConversationWith(conversationId: String) -> NSFetchRequest<Conversation>
    func fetchNonEmptyOnlineConversations() -> NSFetchRequest<Conversation>
}

class ConversationFetchRequester: IConversationFetchRequester {

    func fetchConversations() -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let onlineSortDescriptor = NSSortDescriptor(key: "isOnline", ascending: false)
        request.sortDescriptors = [onlineSortDescriptor, dateSortDescriptor]
        return request
    }

    func fetchOnlineConversations() -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "isOnline == YES")
        return request
    }

    func fetchConversationWith(conversationId: String) -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "conversationId == %@", conversationId)
        return request
    }

    func fetchNonEmptyOnlineConversations() -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "messageHistory.@count > 0 AND user.isOnline == 1")
        return request
    }
}
