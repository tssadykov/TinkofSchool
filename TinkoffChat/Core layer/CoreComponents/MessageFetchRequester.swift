//
//  MessageFetchRequester.swift
//  TinkoffChat
//
//  Created by Тимур on 17/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import CoreData

protocol IMessageFetchRequester {
    func fetchMessagesFrom(conversationId: String) -> NSFetchRequest<Message>
}

class MessageFetchRequester: IMessageFetchRequester {

    func fetchMessagesFrom(conversationId: String) -> NSFetchRequest<Message> {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "conversationId == %@", conversationId)
        let sort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]
        return request
    }
}
