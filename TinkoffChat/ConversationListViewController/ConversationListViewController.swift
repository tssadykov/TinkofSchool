//
//  ConversationListViewController.swift
//  TinkoffChat
//
//  Created by Тимур on 04/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit

class ConversationListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    var conversations: [Conversation] = [Conversation(name: "Алексей", message: "Привет", date: Date(timeIntervalSinceNow: -130968888800000), online: true, hasUnreadMessages: false, messageHistory: [Conversation.Message.incoming("Привет")]),
                                         Conversation(name: "Илья", message: "Привет! Раз два три четыре пять шесть семь восемь девять десят одиннадцать двенадцать", date: Date(timeIntervalSinceNow: -600), online: true, hasUnreadMessages: true, messageHistory: [Conversation.Message.incoming("Привет! Как дела? Как погода?"), Conversation.Message.outgoing("Привет! Раз два три четыре пять шесть семь восемь девять десят одиннадцать двенадцать"),Conversation.Message.incoming("Привет! Как дела? Как погода?"), Conversation.Message.outgoing("прив"),Conversation.Message.incoming("норм"), Conversation.Message.outgoing("Привет! Раз два три четыре пять шесть семь восемь девять десят одиннадцать двенадцать"),Conversation.Message.incoming("Привет! Как дела? Как погода?"), Conversation.Message.outgoing("Привет! Раз два три четыре пять шесть семь восемь девять десят одиннадцать двенадцать"),Conversation.Message.incoming("Привет! Как дела? Как погода?"), Conversation.Message.outgoing("Привет! Раз два три четыре пять шесть семь восемь девять десят одиннадцать двенадцать"),Conversation.Message.outgoing("Привет! Раз два три четыре пять шесть семь восемь девять десят одиннадцать двенадцать"),Conversation.Message.incoming("Привет! Раз два три четыре пять шесть семь восемь девять десят одиннадцать двенадцать")]),
                                         Conversation(name: "Владимир", message: "Привет! Очень очень очень очень очень большое сообщение", date: nil, online: true, hasUnreadMessages: true, messageHistory: [Conversation.Message.incoming("Привет! Как дела? Как погода?"), Conversation.Message.outgoing("Привет! Привет! Привет! Привет! Привет! Привет!"),Conversation.Message.outgoing("Пока-пока"),Conversation.Message.incoming("Привет! Очень очень очень очень очень большое сообщение")]),
                                         Conversation(name: "Дмитрий", message: "Привет Раз два три четыре пять шесть семь восемь девять десят", date: Date(timeIntervalSinceNow: -1209600), online: true, hasUnreadMessages: false, messageHistory: [Conversation.Message.incoming("Привет Раз два три четыре пять шесть семь восемь девять десят")]),
                                         Conversation(name: nil, message: "Привет шесть семь восемь девять десять", date: Date(timeIntervalSinceNow: -1309602), online: false, hasUnreadMessages: false, messageHistory: [Conversation.Message.incoming("Привет шесть семь восемь девять")]),
                                         Conversation(name: nil, message: "Привет шесть семь восемь девять", date: Date(timeIntervalSinceNow: -1309602), online: true, hasUnreadMessages: true, messageHistory: [Conversation.Message.incoming("Привет шесть семь восемь девять")]),
                                         Conversation(name: "Иосиф Сталин", message: "Привет шесть семь восемь", date: Date(timeIntervalSinceNow: -1309600), online: false, hasUnreadMessages: true, messageHistory: [Conversation.Message.incoming("Привет шесть семь восемь")]),
                                         Conversation(name: "Лев Троцкий", message: nil, date: nil, online: true, hasUnreadMessages: false, messageHistory: []),
                                         Conversation(name: "Николай II", message: nil, date: Date(timeIntervalSinceNow: -1309600), online: true, hasUnreadMessages: false, messageHistory: []),
                                         Conversation(name: "Владимир Ильич", message: nil, date: nil, online: true, hasUnreadMessages: false, messageHistory: []),
                                         Conversation(name: "Бруно Марс", message: "Привет", date: Date(timeIntervalSinceNow: -1309600), online: true, hasUnreadMessages: false, messageHistory: [Conversation.Message.incoming("Привет")]),
                                         Conversation(name: "Том Харди", message: "Привет", date: Date(timeIntervalSinceNow: -1309600), online: true, hasUnreadMessages: false, messageHistory: [Conversation.Message.incoming("Привет")]),
                                         Conversation(name: "Дэвид Линч", message: nil, date: Date(timeIntervalSinceNow: -1600), online: false, hasUnreadMessages: true, messageHistory: []),
                                         Conversation(name: "Джаред Лето", message: "Здравствуйте!", date: Date(timeIntervalSinceNow: -1600), online: false, hasUnreadMessages: true, messageHistory: [Conversation.Message.incoming("Здравствуйте!")]),
                                         Conversation(name: "Волк из Ну Погоди", message: "Здравствуйте!", date: Date(timeIntervalSinceNow: -16200), online: false, hasUnreadMessages: false, messageHistory: [Conversation.Message.incoming("Здравствуйте!")]),
                                         Conversation(name: "Анджелина Джоли Вот", message: "Здравствуйте!", date: Date(timeIntervalSinceNow: -16300), online: false, hasUnreadMessages: true, messageHistory: [Conversation.Message.incoming("Здравствуйте!")]),
                                         Conversation(name: "Реджинальд Кеннет Дуайт (Элтон Джон)", message: "Вотс ап", date: Date(timeIntervalSinceNow: -160330), online: false, hasUnreadMessages: true, messageHistory: [Conversation.Message.incoming("Вотс ап")]),
                                         Conversation(name: "Лана Дель Рей", message: nil, date: Date(timeIntervalSinceNow: -1621200), online: false, hasUnreadMessages: true, messageHistory: [Conversation.Message.incoming("Здравствуйте!")]),
                                         Conversation(name: "Вин Дизель", message: "Добрый день", date: nil, online: false, hasUnreadMessages: true, messageHistory: [Conversation.Message.incoming("Добрый день"),Conversation.Message.outgoing("Добрый день")]),
                                         Conversation(name: "Карлос Ирвин Эстевес", message: "Как дела?", date: Date(timeIntervalSinceNow: -1600), online: false, hasUnreadMessages: true, messageHistory: [Conversation.Message.incoming("Как дела?")]),
                                         Conversation(name: "Дональд Трамп", message: "How are you? Make America Great Again", date: Date(timeIntervalSinceNow: -1600), online: false, hasUnreadMessages: true, messageHistory: [Conversation.Message.incoming("How are you? Make America Great Again")]),
                                         Conversation(name: nil, message: "Привет, привет!", date: Date(timeIntervalSinceNow: -1600), online: false, hasUnreadMessages: true, messageHistory: [Conversation.Message.incoming("Привет, привет!")])]
    var onlineConversations: [Conversation] = []
    var offlineConversations: [Conversation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        distributionConversations()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    
    private func distributionConversations() {
        onlineConversations = conversations.filter { $0.online }
        offlineConversations = conversations.filter { !$0.online && ($0.message != nil) }
        onlineConversations.sort(by: sortConversation(firstConversation:secondConversation:))
        offlineConversations.sort(by: sortConversation(firstConversation:secondConversation:))
    }

    private func sortConversation(firstConversation: Conversation, secondConversation: Conversation) -> Bool {
        if let firstDate = firstConversation.date, firstConversation.message != nil {
            if let secondDate = secondConversation.date, secondConversation.message != nil {
                return firstDate.timeIntervalSinceNow > secondDate.timeIntervalSinceNow
            }
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConversationSegue", let indexPath = sender as? IndexPath {
            let conversationViewController = segue.destination as! ConversationViewController
            let conversation: Conversation
            switch indexPath.section {
            case 0:
                conversation = onlineConversations[indexPath.row]
            default:
                conversation = offlineConversations[indexPath.row]
            }
            conversationViewController.conversation = conversation
            
            let backButton = UIBarButtonItem()
            backButton.title = "Назад"
            navigationItem.backBarButtonItem = backButton
        } else if segue.identifier == "ThemesSegue" {
            guard let themesNVC = segue.destination as? UINavigationController, let themesVC = themesNVC.viewControllers.first as? ThemesViewController else { return }
            themesVC.delegate = self
            /*themesVC.colorHandler = { (selectedTheme: UIColor) -> Void in
                UINavigationBar.appearance().barTintColor = selectedTheme
                guard let colorData =  try? NSKeyedArchiver.archivedData(withRootObject: selectedTheme, requiringSecureCoding: false) else { return }
                UserDefaults.standard.set(colorData, forKey: "Theme")
                Logger.shared.logThemeChanged(selectedTheme: selectedTheme)
            }*/
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    @IBAction func unwindToConversationList(unwindSegue: UIStoryboardSegue) {
        
    }
    
}
