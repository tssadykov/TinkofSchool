//
//  ConversationListViewController.swift
//  TinkoffChat
//
//  Created by Тимур on 04/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit
import CoreData

class ConversationListViewController: UIViewController, CommunicationIntegrator {

    @IBOutlet var tableView: UITableView!
    var fetchResultController: NSFetchedResultsController<Conversation>!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        let request = FetchRequestManager.shared.fetchConversations()
        request.fetchBatchSize = 20
        fetchResultController = NSFetchedResultsController(fetchRequest: request,
                                                           managedObjectContext: CoreDataStack.shared.mainContext,
                                                           sectionNameKeyPath: "isOnline",
                                                           cacheName: nil)
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
        } catch {
            assertionFailure("Error due perform fetch on fetchResultController")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        CommunicationManager.shared.delegate = self
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConversationSegue", let indexPath = sender as? IndexPath {
            guard let conversationViewController = segue.destination as? ConversationViewController
                else { super.prepare(for: segue, sender: sender); return }
            let conversation = fetchResultController.object(at: indexPath)
            conversationViewController.conversation = conversation
            let backButton = UIBarButtonItem()
            backButton.title = "Назад"
            navigationItem.backBarButtonItem = backButton
        } else if segue.identifier == "ThemesSegue" {
            guard let themesNVC = segue.destination as? UINavigationController,
                let themesVC = themesNVC.viewControllers.first as? ThemesViewController else { return }
            themesVC.delegate = self
//            themesVC.colorHandler = { (selectedTheme: UIColor) -> Void in
//                UINavigationBar.appearance().barTintColor = selectedTheme
//                DispatchQueue.global(qos: .utility).async {
//                guard let colorData =  try? NSKeyedArchiver.archivedData(withRootObject:
//                          selectedTheme, requiringSecureCoding: false) else { return }
//                UserDefaults.standard.set(colorData, forKey: "Theme")
//                }
//                Logger.shared.logThemeChanged(selectedTheme: selectedTheme)
//            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    @IBAction func unwindToConversationList(unwindSegue: UIStoryboardSegue) {

    }

    func handleError(error: Error) {
        let alert = UIAlertController(title: "Проблемы с соединением", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
