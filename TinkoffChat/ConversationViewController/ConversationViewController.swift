//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Тимур on 05/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var sendButton: UIButton!
    var conversation: Conversation!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    var fetchResultController: NSFetchedResultsController<Message>!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        CommunicationManager.shared.delegate = self
        setupFetchController()
        setupKeyboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        scrollingToBottom()
        sendButton.layer.cornerRadius = sendButton.frame.width * 0.1
        sendButton.layer.borderWidth = 2
        sendButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        sendButton.clipsToBounds = true
        sendButton.isEnabled = false
        conversation.hasUnreadMessages = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = conversation.user?.name ?? "Без имени"
    }

    private func setupKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(gesture:)))
        view.addGestureRecognizer(tapGesture)
        registerNotifications()
    }

    private func setupFetchController() {
        guard let conversationId = conversation.conversationId else { return }
        let request = FetchRequestManager.shared.fetchMessagesFrom(conversationId: conversationId)
        request.fetchBatchSize = 20
        fetchResultController = NSFetchedResultsController(fetchRequest: request,
                                                           managedObjectContext: CoreDataStack.shared.mainContext,
                                                           sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
        } catch {

        }
    }

    @objc func hideKeyboard(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWiilHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let info = notification.userInfo,
            let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        bottomConstraint.constant = keyboardSize.height + 5 - view.safeAreaInsets.bottom
        UIView.animate(withDuration: 0) {
            self.view.layoutIfNeeded()
            self.scrollingToBottom()
        }
    }

    @objc private func keyboardWiilHidden() {
        self.bottomConstraint.constant = 10
        UIView.animate(withDuration: 0) {
            self.view.layoutIfNeeded()
        }
    }

    func scrollingToBottom() {
        guard let fetchedObjects = fetchResultController.fetchedObjects else { return }
        if !fetchedObjects.isEmpty {
            let indexPath = IndexPath(row: fetchedObjects.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    // MARK: - User Interactions

    @IBAction func messageTextChanged(_ sender: UITextField) {
        if messageTextField.text == "" {
            sendButton.isEnabled = false
        } else if conversation.isOnline {
            sendButton.isEnabled = true
        }
    }

    @IBAction func sendButtonTapped(_ sender: UIButton) {
        guard let text = messageTextField.text, let conversationId = conversation.conversationId else { return }
        CommunicationManager.shared.communicator?.sendMessage(string: text, to: conversationId) { succes, error in
            if succes {
                self.messageTextField.text = ""
                self.sendButton.isEnabled = false
            }
            if let error = error {
                print(error.localizedDescription)
                self.view.endEditing(true)
                let alert = UIAlertController(title: "Ошибка при отправке сообщения",
                                              message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}
