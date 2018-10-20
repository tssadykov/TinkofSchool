//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Тимур on 20/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

struct OperationDataManager: DataManager {
    var documentsDirectory: URL
    var archiveURL: URL
    let operationQueue = OperationQueue()
    let operationqewqe = OperationQueue.init
    
    init() {
        documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        archiveURL = documentsDirectory.appendingPathComponent("user_profile").appendingPathExtension("plist")
    }
    
    func saveProfile(new profile: Profile, old: Profile, completion: @escaping CompletionSaveHandler) {
        let saveOperation = SaveProfileOperation()
        saveOperation.archiveURL = archiveURL
        saveOperation.completionHandler = completion
        saveOperation.newProfile = profile
        saveOperation.oldProfile = old
        operationQueue.addOperation(saveOperation)
    }
    
    func getProfile(completion: @escaping CompletionProfileLoader) {
        let loadOperation = ProfileLoadingOperation()
        loadOperation.archiveURL = archiveURL
        loadOperation.completionHandler = completion
        operationQueue.addOperation(loadOperation)
    }
}

class ProfileLoadingOperation: Operation {
    var profile: Profile!
    var archiveURL: URL!
    var completionHandler: CompletionProfileLoader!
    
    override func main() {
        sleep(3)
        let name = UserDefaults.standard.string(forKey: "user_name") ?? "Без имени"
        let description = UserDefaults.standard.string(forKey: "user_description") ?? ""
        let image: UIImage
        if let imageData =  try? Data(contentsOf: archiveURL), UIImage(data: imageData) != nil {
            image = UIImage(data: imageData)!
        } else {
            image = UIImage(named: "placeholder-user")!
        }
        profile = Profile(name: name, description: description, userImage: image)
        OperationQueue.main.addOperation { self.completionHandler(self.profile) }
    }
}

class SaveProfileOperation: Operation {
    var newProfile: Profile!
    var oldProfile: Profile!
    var completionHandler: CompletionSaveHandler!
    var archiveURL: URL!
    
    override func main() {
        sleep(3)
        if newProfile.name != oldProfile.name {
            UserDefaults.standard.set(newProfile.name, forKey: "user_name")
        }
        if newProfile.description != oldProfile.name {
            UserDefaults.standard.set(newProfile.description, forKey: "user_description")
        }
        if newProfile.userImage.jpegData(compressionQuality: 1.0) != oldProfile.userImage.jpegData(compressionQuality: 1.0) {
            guard let imageData = newProfile.userImage.jpegData(compressionQuality: 1.0) else {
                OperationQueue.main.addOperation {
                    self.completionHandler(ImageError.convertDataError)
                }
                return
            }
            do {
                try imageData.write(to: archiveURL, options: .noFileProtection)
            } catch let error {
                self.completionHandler(error)
            }
        }
        self.completionHandler(nil)
    }
}

