//
//  ConversationListViewController.swift
//  TinkoffChat
//
//  Created by Тимур on 04/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit

class ConversationListViewController: UIViewController {

    var onlineConversations: [Conversation] = [Conversation(name: "Алексей", message: "Привет", date: Date(timeIntervalSinceNow: -1309600), online: true, hasUnreadMessages: false, messageHistory: [Conversation.Message.incoming("Привет")]), Conversation(name: "Алексей", message: "Привет! Раз два три четыре пять шесть семь восемь девять десят одиннадцать двенадцать", date: Date(timeIntervalSinceNow: -600), online: true, hasUnreadMessages: true, messageHistory: [Conversation.Message.incoming("Привет")]), Conversation(name: "Алексей", message: "Привет Раз два три четыре пять шесть семь восемь девять десят", date: Date(timeIntervalSinceNow: -1209600), online: true, hasUnreadMessages: false, messageHistory: [Conversation.Message.incoming("Привет")]), Conversation(name: "Алексей", message: "Привет шесть семь восемь девять", date: Date(timeIntervalSinceNow: -1309600), online: true, hasUnreadMessages: true, messageHistory: [Conversation.Message.incoming("Привет")]), Conversation(name: "Алексей", message: "Привет", date: Date(timeIntervalSinceNow: -1309600), online: true, hasUnreadMessages: false, messageHistory: [Conversation.Message.incoming("Привет")]), Conversation(name: "Алексей", message: "Привет", date: Date(timeIntervalSinceNow: -1309600), online: true, hasUnreadMessages: false, messageHistory: [Conversation.Message.incoming("Привет")]), Conversation(name: "Алексей", message: "Привет", date: Date(timeIntervalSinceNow: -1309600), online: true, hasUnreadMessages: false, messageHistory: [Conversation.Message.incoming("Привет")]), Conversation(name: "Алексей", message: "Привет", date: Date(timeIntervalSinceNow: -1309600), online: true, hasUnreadMessages: false, messageHistory: [Conversation.Message.incoming("Привет")])]
    var offlineConversations: [Conversation] = [Conversation(name: "Андрей", message: "Пока", date: Date(timeIntervalSinceNow: -1600), online: false, hasUnreadMessages: true, messageHistory: [Conversation.Message.incoming("Привет")])]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
