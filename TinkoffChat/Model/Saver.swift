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
    /*func saveNameWith(_ name: String)
    func saveDescriptionWith(_ description: String)
    func saveImageWith(_ image: UIImage) throws*/
    func getProfile(completion: @escaping CompletionProfileLoader)
    func saveProfile(new profile: Profile, old: Profile, completion: @escaping CompletionSaveHandler)
}

enum ImageError: Error {
    case convertDataError
}
