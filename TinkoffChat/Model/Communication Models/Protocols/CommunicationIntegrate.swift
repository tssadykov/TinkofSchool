//
//  CommunicationIntegrate.swift
//  TinkoffChat
//
//  Created by Тимур on 26/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

protocol CommunicationIntegrate : class {
    func updateUserData()
    func handleError(error: Error)
}
