//
//  CommunicationIntegrate.swift
//  TinkoffChat
//
//  Created by Тимур on 26/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//
import UIKit

protocol CommunicationHandler: class {
    func handleError(error: Error)
}

protocol CommunicationUpdater: class {
    func updateLostUser(userId: String)
    func updateFoundedUser(userId: String)
}

extension CommunicationHandler where Self: UIViewController {
    func handleError(error: Error) {
        let alert = UIAlertController(title: "Проблемы с соединением", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
