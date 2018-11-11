//
//  User.swift
//  TinkoffChat
//
//  Created by Тимур on 09/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import CoreData

extension User {
    
    static func insertUserWith(id: String, in context: NSManagedObjectContext) -> User {
        guard let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User else {
            fatalError("Can't insert User")
        }
        user.userId = id
        return user
    }
    
    static func findOrInsertUser(id: String, in context: NSManagedObjectContext) -> User? {
        let request = FetchRequestManager.shared.fetchUserWith(id: id)
        do {
            let users = try context.fetch(request)
            assert(users.count < 2, "Users with id \(id) more than 1")
            if !users.isEmpty {
                return users.first!
            } else {
                return User.insertUserWith(id:id, in: context)
            }
        } catch {
            assertionFailure("Can't get users by a fetch. May be there is an incorrect fetch")
            return nil
        }
    }
}
