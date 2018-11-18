//
//  Profile.swift
//  TinkoffChat
//
//  Created by Тимур on 20/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit

protocol IProfile {
    var name: String { get set }
    var description: String { get set }
    var userImageData: Data { get set }
}

struct Profile: IProfile {
    var name: String
    var description: String
    var userImageData: Data
}
