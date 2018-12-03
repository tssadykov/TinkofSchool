//
//  CGPoint+operator+.swift
//  TinkoffChat
//
//  Created by Тимур on 02/12/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

extension CGPoint {
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }

    static func += (left: inout CGPoint, right: CGPoint) {
        left.x += right.x
        left.y += right.y
    }
}
