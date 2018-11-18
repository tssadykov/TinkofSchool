//
//  UserFetchRequester.swift
//  TinkoffChat
//
//  Created by Тимур on 17/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import CoreData

protocol IUserFetchRequester {
    func fetchUserWith(userId: String) -> NSFetchRequest<User>
    func fetchOnlineUsers() -> NSFetchRequest<User>
}

class UserFetchRequester: IUserFetchRequester {

    func fetchUserWith(userId: String) -> NSFetchRequest<User> {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userId)
        return request
    }

    func fetchOnlineUsers() -> NSFetchRequest<User> {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "isOnline == YES")
        return request
    }
}
