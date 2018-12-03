//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Тимур on 05/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController, CommunicationHandler, CommunicationUpdater {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var sendButton: UIButton!
    var nameLabel: UILabel!
    var conversation: Conversation!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    var conversationInteractor: IConversationInteractor!
    var fetchResultController: NSFetchedResultsController<Message>!
    var assembly: IPresentationAssembly!
    var canSendMessage: Bool = false {
        didSet {
            guard canSendMessage != oldValue else { return }
            sendButton.isEnabled = canSendMessage
            animateSendButton()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
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
        sendButton.backgroundColor = .gray
        conversation.hasUnreadMessages = false
        navigationItem.largeTitleDisplayMode = .never
        nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        nameLabel.text = conversation.user?.name ?? "Без имени"
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        navigationItem.titleView = nameLabel
        nameLabel.transform = CGAffineTransform(scaleX: 1/1.1, y: 1/1.1)
        conversationInteractor.setUpdater(communicationUpdater: self)
        conversationInteractor.setHandler(communicationHandler: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateNameLabel()
    }

    private func setupKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(gesture:)))
        view.addGestureRecognizer(tapGesture)
        registerNotifications()
    }

    private func setupFetchController() {
        guard let userId = conversation.conversationId else { return }
        guard conversationInteractor.setupMessagesFetchedResultController(userID:) != nil else {
            fatalError("Function setupMessagesFetchedResultController(conversationID:) is not implemented")
        }
        fetchResultController = conversationInteractor.setupMessagesFetchedResultController!(userID: userId)
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

    func updateUserData() {
        canSendMessage = conversation.isOnline
        animateNameLabel()
    }

    func updateLostUser(userId: String) {
        if userId == conversation.conversationId {
            conversation.isOnline = false
            canSendMessage = conversation.isOnline
            animateNameLabel()
        }
    }

    func updateFoundedUser(userId: String) {
        if userId == conversation.conversationId {
            conversation.isOnline = true
            updateSendButton()
            animateNameLabel()
        }
    }

    func animateSendButton() {
        let transform = CATransform3DMakeScale(1.1, 1.1, 1)
        let firstAnimation = CABasicAnimation(keyPath: "transform")
        firstAnimation.toValue = transform
        firstAnimation.duration = 1
        firstAnimation.fillMode = .forwards
        let secondAnimation = CABasicAnimation(keyPath: "transform")
        secondAnimation.toValue = CATransform3DIdentity
        secondAnimation.beginTime = 1.5
        secondAnimation.duration = 1
        secondAnimation.fillMode = .forwards
        let group = CAAnimationGroup()
        group.duration = 3.5
        group.animations = [firstAnimation, secondAnimation]
        let newColor = canSendMessage ? UIColor.blue : UIColor.gray
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.beginTime = firstAnimation.beginTime
        colorAnimation.fromValue = sendButton.backgroundColor!.cgColor
        colorAnimation.toValue = newColor.cgColor
        colorAnimation.duration = 3.5
        sendButton.layer.add(group, forKey: nil)
        sendButton.layer.add(colorAnimation, forKey: nil)
        sendButton.backgroundColor = newColor
    }

    func animateNameLabel() {
        let scaleFactor = conversation.isOnline ? 1.0 : 1.0/1.1
        let textColor = conversation.isOnline ? UIColor.green : UIColor.black
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            self.nameLabel.transform = CGAffineTransform(scaleX: CGFloat(scaleFactor), y: CGFloat(scaleFactor))
            self.nameLabel.textColor = textColor
        }, completion: nil)
    }

    func scrollingToBottom() {
        guard let fetchedObjects = fetchResultController.fetchedObjects else { return }
        if !fetchedObjects.isEmpty {
            let indexPath = IndexPath(row: fetchedObjects.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }

    func updateSendButton() {
        if messageTextField.text == "" {
            canSendMessage = false
        } else if conversation.isOnline {
            canSendMessage = true
        }
    }
    // MARK: - User Interactions

    @IBAction func messageTextChanged(_ sender: UITextField) {
        updateSendButton()
    }

    @IBAction func sendButtonTapped(_ sender: UIButton) {
        guard let text = messageTextField.text, let conversationId = conversation.conversationId else { return }
        conversationInteractor.sendMessage(text: text, conversationId: conversationId) { succes, error in
            if succes {
                self.messageTextField.text = ""
                self.canSendMessage = false
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
