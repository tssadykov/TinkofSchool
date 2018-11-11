//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Тимур on 20/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

struct GCDDataManager: DataManager {
    
    let documentsDirectory: URL
    let archiveURL: URL
    let syncQueue = DispatchQueue(label: "com.tssadykov", qos: .userInitiated) // делаем очередь последовательной, чтобы избежать race condition, т.к. если попробовать загрузить профиль во время сохранения, может загрузиться старый профиль
    
    init() {
        documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        archiveURL = documentsDirectory.appendingPathComponent("user_profile").appendingPathExtension("plist")
    }
    
    func saveNameWith(_ name: String) {
        UserDefaults.standard.set(name, forKey: "user_name")
    }
    
    func saveDescriptionWith(_ description: String) {
        UserDefaults.standard.set(description, forKey: "user_description")
    }
    
    func saveImageWith(_ image: UIImage) throws {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { throw SaveErrors.convertDataError }
        do {
            try imageData.write(to: archiveURL, options: .noFileProtection)
        } catch let error {
            throw error
        }
    }
    
    func getProfile(completion: @escaping CompletionProfileLoader){
        syncQueue.async {
            let name = UserDefaults.standard.string(forKey: "user_name") ?? "Без имени"
            let description = UserDefaults.standard.string(forKey: "user_description") ?? ""
            let image: UIImage
            if let imageData =  try? Data(contentsOf: self.archiveURL), UIImage(data: imageData) != nil {
                image = UIImage(data: imageData)!
            } else {
                image = UIImage(named: "placeholder-user")!
            }
            let profile = Profile(name: name, description: description, userImage: image)
            DispatchQueue.main.async {
                completion(profile)
            }
        }
    }
    
    func saveProfile(newProfile: Profile, oldProfile: Profile, completion: @escaping CompletionSaveHandler) {
        syncQueue.async {
            if newProfile.name != oldProfile.name {
                self.saveNameWith(newProfile.name)
            }
            if newProfile.description != oldProfile.description {
                self.saveDescriptionWith(newProfile.description)
            }
            if newProfile.userImage.jpegData(compressionQuality: 1.0) != oldProfile.userImage.jpegData(compressionQuality: 1.0) {
                do {
                    try self.saveImageWith(newProfile.userImage)
                } catch let error {
                    DispatchQueue.main.async {
                        completion(error)
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
}
