//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Тимур on 20/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

struct GCDDataManager: ProfileDataManager {

    let documentsDirectory: URL
    let archiveURL: URL
    // делаем очередь последовательной, чтобы избежать race condition,
    // т.к. если попробовать загрузить профиль во время сохранения, может загрузиться старый профиль
    let syncQueue = DispatchQueue(label: "com.tssadykov", qos: .userInitiated)

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

    func saveImageWith(_ imageData: Data) throws {
        do {
            try imageData.write(to: archiveURL, options: .noFileProtection)
        } catch let error {
            throw error
        }
    }

    func getProfile(completion: @escaping CompletionProfileLoader) {
        syncQueue.async {
            let name = UserDefaults.standard.string(forKey: "user_name") ?? "Без имени"
            let description = UserDefaults.standard.string(forKey: "user_description") ?? ""
            let imageData: Data = (try? Data(contentsOf: self.archiveURL))
                ?? UIImage(named: "placeholder-user")!.jpegData(compressionQuality: 1.0)!
            let profile = Profile(name: name, description: description, userImageData: imageData)
            DispatchQueue.main.async {
                completion(profile)
            }
        }
    }

    func saveProfile(newProfile: IProfile, oldProfile: IProfile, completion: @escaping CompletionSaveHandler) {
        syncQueue.async {
            if newProfile.name != oldProfile.name {
                self.saveNameWith(newProfile.name)
            }
            if newProfile.description != oldProfile.description {
                self.saveDescriptionWith(newProfile.description)
            }
            if newProfile.userImageData
                != oldProfile.userImageData {
                do {
                    try self.saveImageWith(newProfile.userImageData)
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
