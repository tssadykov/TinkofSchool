//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Тимур on 05/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    var conversation: Conversation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = conversation.name ?? "Без имени"
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
