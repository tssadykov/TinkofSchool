//
//  ConversationTableViewCell.swift
//  TinkoffChat
//
//  Created by Тимур on 04/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell, ConversationCellConfiguration {

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var messageLabel: UILabel!
    
    var name: String? {
        didSet {
            nameLabel.text = name ?? "Без имени"
        }
    }
    
    var message: String?  {
        didSet {
            let fontName: String
            if message != nil {
                fontName = "Helvetica"
            } else {
                fontName = "Georgia"
            }
            let font = UIFont(name: fontName, size: 18)!
            let attributedString = NSAttributedString(string: message ?? "No messages yet", attributes: [.font : font])
            messageLabel.attributedText = attributedString
        }
    }
    
    var date: Date? {
        didSet {
            guard let date = date, message != nil else { dateLabel.text = ""; return }
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            if -date.timeIntervalSinceNow > 86400 {
                dateFormatter.setLocalizedDateFormatFromTemplate("dd MMM")
            } else {
                dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
            }
            dateLabel.text = dateFormatter.string(from: date)
        }
    }
    
    var online: Bool = false {
        didSet {
            if online {
                backgroundColor = #colorLiteral(red: 0.8909936547, green: 0.9486134648, blue: 0.7396917939, alpha: 1)
            } else {
                backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
    }
    
    var hasUnreadMessages: Bool = false {
        didSet {
            guard let message = message else { return }
            let fontName: String
            if hasUnreadMessages {
                fontName = "Helvetica-Bold"
            } else {
                fontName = "Helvetica"
            }
            let font = UIFont(name: fontName, size: 18)!
            let attributedString = NSAttributedString(string: message, attributes: [.font : font])
            messageLabel.attributedText = attributedString
        }
    }
}
