//
//  TableViewDataSource.swift
//  TinkoffChat
//
//  Created by Тимур on 05/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation?.messageHistory.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageCell: MessageTableViewCell
        switch conversation.messageHistory[indexPath.row] {
        case .incoming(let message):
            messageCell = tableView.dequeueReusableCell(withIdentifier: "MessageIncomingCell", for: indexPath) as! MessageTableViewCell
            messageCell.textMessage = message
        case .outgoing(let message):
            messageCell = tableView.dequeueReusableCell(withIdentifier: "MessageOutgoingCell", for: indexPath) as! MessageTableViewCell
            messageCell.textMessage = message
        }
        return messageCell
    }
}
