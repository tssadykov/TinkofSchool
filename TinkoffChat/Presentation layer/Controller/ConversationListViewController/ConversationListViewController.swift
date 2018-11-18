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
    var assembly: IPresentationAssembly!
    var conversationListInteractor: IConversationListFetcher!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        if conversationListInteractor.setupConversationsFetchedResultController == nil {
            fatalError("Function setupConversationsFetchedResultController is not implemented")
        }
        fetchResultController = conversationListInteractor.setupConversationsFetchedResultController!()
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
        } catch {
            assertionFailure("Error due perform fetch on fetchResultController")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        conversationListInteractor.setIntegrator(communicationIntegrator: self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConversationSegue", let indexPath = sender as? IndexPath {
            guard let conversationViewController = segue.destination as? ConversationViewController
                else { super.prepare(for: segue, sender: sender); return }
            let conversation = fetchResultController.object(at: indexPath)
            conversationViewController.conversation = conversation
            let backButton = UIBarButtonItem()
            conversationViewController.conversationInteractor = assembly.getConversationInteractor()
            conversationViewController.assembly = assembly
            backButton.title = "Назад"
            navigationItem.backBarButtonItem = backButton
        } else if segue.identifier == "ThemesSegue" {
            guard let themesNVC = segue.destination as? UINavigationController,
                let themesVC = themesNVC.viewControllers.first as? ThemesViewController else { return }
            themesVC.delegate = self
            themesVC.assembly = assembly
//            themesVC.colorHandler = { (selectedTheme: UIColor) -> Void in
//                UINavigationBar.appearance().barTintColor = selectedTheme
//                DispatchQueue.global(qos: .utility).async {
//                guard let colorData =  try? NSKeyedArchiver.archivedData(withRootObject:
//                          selectedTheme, requiringSecureCoding: false) else { return }
//                UserDefaults.standard.set(colorData, forKey: "Theme")
//                }
//                Logger.shared.logThemeChanged(selectedTheme: selectedTheme)
//            }
        } else if segue.identifier == "ProfileSegue" {
            guard let navigationVC = segue.destination as? UINavigationController,
                let profileVC = navigationVC.topViewController as? ProfileViewController else { return }
            profileVC.profileInteractor = assembly.getProfileInteractor()
            profileVC.assembly = assembly
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    @IBAction func unwindToConversationList(unwindSegue: UIStoryboardSegue) {
    }
}
