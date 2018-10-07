//
//  TableViewDataSource.swift
//  TinkoffChat
//
//  Created by Тимур on 04/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit

extension ConversationListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return onlineConversations.count
        default:
            return offlineConversations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conversationCell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationTableViewCell
        let conversation: Conversation
        switch indexPath.section {
        case 0:
            conversation = onlineConversations[indexPath.row]
        default:
            conversation = offlineConversations[indexPath.row]
        }
        conversationCell.name = conversation.name
        conversationCell.message = conversation.message
        conversationCell.date = conversation.date
        conversationCell.hasUnreadMessages = conversation.hasUnreadMessages
        conversationCell.online = conversation.online
        return conversationCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        default:
            return "History"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ConversationSegue", sender: indexPath)
    }
}
