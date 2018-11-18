//
//  MessageTableViewCell.swift
//  TinkoffChat
//
//  Created by Тимур on 05/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell, MessageCellConfiguration {
    @IBOutlet private var messageLabel: UILabel!
    var textMessage: String? {
        didSet {
            messageLabel.text = textMessage
            messageLabel.layer.cornerRadius = 5
            messageLabel.clipsToBounds = true
        }
    }

}
