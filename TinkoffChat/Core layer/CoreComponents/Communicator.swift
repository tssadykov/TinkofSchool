//
//  Communicator.swift
//  TinkoffChat
//
//  Created by Тимур on 25/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

typealias MessageHandler = (_ succes: Bool, _ error: Error?) -> Void

protocol Communicator {
    func sendMessage(text: String, to userId: String, completionHandler: MessageHandler?)
    func startCommunication(name: String)
    var delegate: ICommunicationManager? {get set}
    var online: Bool {get set}
}
