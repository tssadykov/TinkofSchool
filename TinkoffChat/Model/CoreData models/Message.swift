//
//  Message.swift
//  TinkoffChat
//
//  Created by Тимур on 09/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import CoreData

extension Message {
    static func insertNewMessage(in context: NSManagedObjectContext) -> Message {
        guard let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message else {
            fatalError("Can't create Message entity")
        }
        return message
    }
    
    static func findMessagesFrom(conversationId: String, in context: NSManagedObjectContext) -> [Message]? {
        let request = FetchRequestManager.shared.fetchMessagesFrom(conversationId: conversationId)
        do {
            let messages = try context.fetch(request)
            return messages
        } catch {
            assertionFailure("Can't get messages by a fetch. May be there is an incorrect fetch")
            return nil
        }
    }
}
