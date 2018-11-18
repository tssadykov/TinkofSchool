//
//  ProfileInteractor.swift
//  TinkoffChat
//
//  Created by Тимур on 18/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

protocol IProfileInteractor {
    var profile: IProfile! { get set }
    var profileDataManager: ProfileDataManager { get set }
    func loadProfile(completion: @escaping () -> Void)
    func saveProfile(name: String, description: String, imageData: Data, completion: @escaping CompletionSaveHandler)
    var name: String { get }
    var description: String { get }
    var imageData: Data { get }
}

class ProfileInteractor: IProfileInteractor {
    lazy var description: String = {
        return profile.description
    }()

    lazy var name: String = {
        return profile.name
    }()

    lazy var imageData: Data = {
        return profile.userImageData
    }()

    var profile: IProfile!

    var profileDataManager: ProfileDataManager

    init(profileDataManager: ProfileDataManager) {
        self.profileDataManager = profileDataManager
    }

    func loadProfile(completion: @escaping () -> Void) {
        profileDataManager.getProfile { (profile) in
            self.profile = profile
            completion()
        }
    }

    func saveProfile(name: String, description: String, imageData: Data, completion: @escaping CompletionSaveHandler) {
        let newProfile = Profile(name: name, description: description, userImageData: imageData)
        profileDataManager.saveProfile(newProfile: newProfile, oldProfile: profile) { (error) in
            if error == nil {
                self.profile = newProfile
            }
            completion(error)
        }
    }

}
