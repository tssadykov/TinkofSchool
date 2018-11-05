//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by Тимур on 02/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

class StorageManager {
    private let coreDataStack = CoreDataStack.shared
    
    func loadAppUser(completion: @escaping (AppUser?) -> Void) {
        AppUser.getAppUser(in: coreDataStack.saveContext) { (appUser) in
            DispatchQueue.main.async {
                completion(appUser)
            }
        }
    }
    
    func saveAppUser(completion: @escaping CompletionSaveHandler) {
        coreDataStack.performSave(in: coreDataStack.saveContext) { (error) in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
}
