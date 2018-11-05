//
//  Saver.swift
//  TinkoffChat
//
//  Created by Тимур on 20/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

typealias CompletionSaveHandler = (Error?) -> Void
typealias CompletionProfileLoader = (Profile) -> Void

protocol DataManager {
    func getProfile(completion: @escaping CompletionProfileLoader)
    func saveProfile(profile: AppUser, newName: String, newDescription: String, newImageData: Data, completion: @escaping CompletionSaveHandler)
}

enum ImageError: Error {
    case convertDataError
}
