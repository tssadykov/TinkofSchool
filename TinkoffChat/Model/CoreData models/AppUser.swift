//
//  AppUser.swift
//  TinkoffChat
//
//  Created by Тимур on 02/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import CoreData

extension AppUser {
    static func getRequest(model: NSManagedObjectModel) -> NSFetchRequest<AppUser>? {
        let template = "AppUser"
        guard let request = model.fetchRequestTemplate(forName: template) as? NSFetchRequest<AppUser> else {
            assert(false, "No template with typename \(template)")
            return nil }
        return request
    }
    
    static func insertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        guard let appUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as? AppUser else {
            return nil
        }
        appUser.name = UIDevice.current.name
        appUser.userImageData = UIImage(named: "placeholder-user")!.jpegData(compressionQuality: 1.0)
        appUser.descriptionUser = ""
        return appUser
    }
    
    static func getAppUser(in context: NSManagedObjectContext, completion: @escaping (AppUser?) -> Void) {
        context.perform {
            guard let model = context.persistentStoreCoordinator?.managedObjectModel else { return }
            guard let request = AppUser.getRequest(model: model) else { return }
            var appUser: AppUser?
            do {
                let results = try context.fetch(request)
                assert(results.count < 2, "App users are more than one")
                if !results.isEmpty {
                    appUser = results.first!
                } else {
                    appUser = AppUser.insertAppUser(in: context)
                }
                completion(appUser)
            } catch {
                print("Failed to fetch AppUser: \(error)")
                completion(nil)
            }
        }
    }
}
