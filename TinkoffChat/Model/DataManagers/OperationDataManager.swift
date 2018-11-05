//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Тимур on 20/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

struct OperationDataManager {
    var documentsDirectory: URL
    var archiveURL: URL
    let operationQueue = OperationQueue()
    
    init() {
        documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        archiveURL = documentsDirectory.appendingPathComponent("user_profile").appendingPathExtension("plist")
        operationQueue.qualityOfService = .userInitiated
        operationQueue.maxConcurrentOperationCount = 1 // делаем очередь последовательной, чтобы избежать race condition, т.к. если попробовать загрузить профиль во время сохранения, может загрузиться старый профиль
    }
    
    func saveProfile(newProfile: Profile, oldProfile: Profile, completion: @escaping CompletionSaveHandler) {
        let saveOperation = SaveProfileOperation()
        saveOperation.archiveURL = archiveURL
        saveOperation.completionHandler = completion
        saveOperation.newProfile = newProfile
        saveOperation.oldProfile = oldProfile
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
        OperationQueue.main.addOperation {
            self.completionHandler(nil)
        }
    }
}

