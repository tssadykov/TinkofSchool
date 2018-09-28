//
//  UIApplicationState extensions.swift
//  TinkoffChat
//
//  Created by Тимур on 21.09.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication.State: CustomStringConvertible {
    public var description: String {
        switch self {
        case .active:
            return("active")
        case .inactive:
            return("inactive")
        case .background:
            return("background")
        }
    }
}
