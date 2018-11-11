//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by Тимур on 02/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

class StorageManager: DataManager {
    
    private let coreDataStack = CoreDataStack.shared
    
    func getProfile(completion: @escaping CompletionProfileLoader) {
        AppUser.getAppUser(in: coreDataStack.saveContext) { (appUser) in
            let profile: Profile
            if let appUser = appUser {
                let name = appUser.name ?? UIDevice.current.name
                let descritption = appUser.descriptionUser ?? ""
                let image: UIImage
                if let imageData = appUser.userImageData {
                    image = UIImage(data: imageData) ?? UIImage(named: "placeholder-user")!
                } else {
                    image = UIImage(named: "placeholder-user")!
                }
                profile = Profile(name: name, description: descritption, userImage: image)
                DispatchQueue.main.async {
                    completion(profile)
                }
            } else {
                assert(false, "AppUser is nil")
            }
        }
    }
    
    func saveProfile(newProfile: Profile, oldProfile: Profile, completion: @escaping CompletionSaveHandler) {
        AppUser.getAppUser(in: coreDataStack.saveContext) { (appUser) in
            guard let appUser = appUser else {
                DispatchQueue.main.async {
                    completion(SaveErrors.loadDataError)
                }
                return
            }
            if newProfile.name != oldProfile.name {
                appUser.name = newProfile.name
            }
            if newProfile.description != oldProfile.description {
                appUser.descriptionUser = newProfile.description
            }
            if newProfile.userImage.jpegData(compressionQuality: 1.0) != oldProfile.userImage.jpegData(compressionQuality: 1.0) {
                appUser.userImageData = newProfile.userImage.jpegData(compressionQuality: 1.0)
            }
            self.coreDataStack.performSave(in: self.coreDataStack.saveContext) { (error) in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
}
