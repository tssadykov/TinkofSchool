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
    func saveProfile(newProfile: Profile, oldProfile: Profile, completion: @escaping CompletionSaveHandler)
}

enum SaveErrors: Error {
    case convertDataError
    case loadDataError
}
