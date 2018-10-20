//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Тимур on 20/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

struct GCDDataManager: DataManager {
    
    var documentsDirectory: URL
    var archiveURL: URL

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
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { throw ImageError.convertDataError }
        do {
            try imageData.write(to: archiveURL, options: .noFileProtection)
        } catch let error {
            throw error
        }
    }
    
    func getProfile(completion: @escaping CompletionProfileLoader){
        DispatchQueue.global(qos: .utility).async {
            sleep(3)
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
    
    func saveProfile(new profile: Profile, old: Profile, completion: @escaping CompletionSaveHandler) {
        DispatchQueue.global(qos: .utility).async {
            sleep(3)
            if profile.name != old.name {
                self.saveNameWith(profile.name)
            }
            if profile.description != old.name {
                self.saveDescriptionWith(profile.description)
            }
            if profile.userImage != old.userImage {
                do {
                    try self.saveImageWith(profile.userImage)
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
