//
//  FetchRequestManager.swift
//  TinkoffChat
//
//  Created by Тимур on 08/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import CoreData

class FetchRequestManager {
    
    static let shared = FetchRequestManager()
    private init() { }
    
    func fetchConversations() -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        //request.predicate = NSPredicate(format: "isOnline == YES")
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
    
    func fetchConversationWith(id: String) -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "conversationId == %@", id)
        return request
    }
    
    func fetchUserWith(id: String) -> NSFetchRequest<User> {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", id)
        return request
    }
    
    func fetchOnlineUser() -> NSFetchRequest<User> {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "isOnline == YES")
        return request
    }
    
    func fetchMessagesFrom(conversationId: String) -> NSFetchRequest<Message> {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "conversationId == %@", conversationId)
        let sort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]
        return request
    }
 }
