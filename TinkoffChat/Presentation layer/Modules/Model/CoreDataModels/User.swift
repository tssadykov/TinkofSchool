//
//  User.swift
//  TinkoffChat
//
//  Created by Тимур on 09/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import CoreData

extension User {

    static func insertUserWith(userId: String, in context: NSManagedObjectContext) -> User {
        guard let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User else {
            fatalError("Can't insert User")
        }
        user.userId = userId
        return user
    }

    static func findOrInsertUser(userId: String,
                                 in context: NSManagedObjectContext,
                                 by userFetchRequester: IUserFetchRequester) -> User? {
        let request = userFetchRequester.fetchUserWith(userId: userId)
        do {
            let users = try context.fetch(request)
            assert(users.count < 2, "Users with id \(userId) more than 1")
            if !users.isEmpty {
                return users.first!
            } else {
                return User.insertUserWith(userId: userId, in: context)
            }
        } catch {
            assertionFailure("Can't get users by a fetch. May be there is an incorrect fetch")
            return nil
        }
    }
}
