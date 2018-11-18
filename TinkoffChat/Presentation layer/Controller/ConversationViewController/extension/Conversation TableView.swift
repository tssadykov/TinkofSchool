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
        guard let sections = fetchResultController.sections else { return 0 }
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = fetchResultController.object(at: indexPath)
        if message.isIncoming {
            guard let messageCell = tableView.dequeueReusableCell(withIdentifier: "MessageIncomingCell",
                                                                  for: indexPath) as? MessageTableViewCell else {
                                                                    return UITableViewCell() }
            messageCell.textMessage = message.text
            return messageCell
        } else {
            guard let messageCell = tableView.dequeueReusableCell(withIdentifier: "MessageOutgoingCell",
                                                                  for: indexPath) as? MessageTableViewCell else {
                                                                    return UITableViewCell() }
            messageCell.textMessage = message.text
            return messageCell
        }
    }
}
