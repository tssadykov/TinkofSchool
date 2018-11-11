//
//  CommunicatorDelegate.swift
//  TinkoffChat
//
//  Created by Тимур on 25/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

protocol CommunicatorDelegate: class {
    //discovering
    func didFoundUser(userId: String, userName: String?)
    func didLostUser(userId: String)

    //errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)

    //messages
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}
