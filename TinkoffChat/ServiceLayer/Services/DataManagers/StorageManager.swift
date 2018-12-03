//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by Тимур on 02/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

class StorageManager: ProfileDataManager {

    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func getProfile(completion: @escaping CompletionProfileLoader) {
        AppUser.getAppUser(in: coreDataStack.saveContext) { (appUser) in
            let profile: Profile
            if let appUser = appUser {
                let name = appUser.currentUser?.name ?? UIDevice.current.name
                let descritption = appUser.descriptionUser ?? ""
                let imageData = appUser.userImageData ??
                    UIImage(named: "placeholder-user")!.jpegData(compressionQuality: 1.0)
                profile = Profile(name: name, description: descritption, userImageData: imageData!)
                DispatchQueue.main.async {
                    completion(profile)
                }
            } else {
                assert(false, "AppUser is nil")
            }
        }
    }

    func saveProfile(newProfile: IProfile, oldProfile: IProfile, completion: @escaping CompletionSaveHandler) {
        AppUser.getAppUser(in: coreDataStack.saveContext) { (appUser) in
            guard let appUser = appUser else {
                DispatchQueue.main.async {
                    completion(SaveErrors.loadDataError)
                }
                return
            }
            if newProfile.name != oldProfile.name {
                appUser.currentUser?.name = newProfile.name
            }
            if newProfile.description != oldProfile.description {
                appUser.descriptionUser = newProfile.description
            }
            if newProfile.userImageData
                != oldProfile.userImageData {
                appUser.userImageData = newProfile.userImageData
            }
            self.coreDataStack.performSave(in: self.coreDataStack.saveContext) { (error) in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
}
