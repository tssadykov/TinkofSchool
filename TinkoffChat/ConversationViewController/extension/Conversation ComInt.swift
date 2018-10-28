//
//  Conversation ComInt.swift
//  TinkoffChat
//
//  Created by Тимур on 27/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit

extension ConversationViewController: CommunicationIntegrate {
    
    func updateUserData() {
        if !conversation.online {
            sendButton.isEnabled = false
        }
        tableView.reloadData()
        scrollingToBottom()
    }
    
    func handleError(error: Error) {
        self.view.endEditing(true)
        let alert = UIAlertController(title: "Проблемы с соединением", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
