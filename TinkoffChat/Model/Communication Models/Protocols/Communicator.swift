//
//  Communicator.swift
//  TinkoffChat
//
//  Created by Тимур on 25/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

typealias MessageHandler = (_ succes: Bool, _ error: Error?) -> ()

protocol Communicator {
    func sendMessage(string: String, to userId: String, completionHandler: MessageHandler?)
    var delegate: CommunicatorDelegate? {get set}
    var online: Bool {get set}
}
