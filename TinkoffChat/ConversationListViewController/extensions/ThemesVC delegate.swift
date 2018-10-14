//
//  ThemesVC delegate.swift
//  TinkoffChat
//
//  Created by Тимур on 11/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//
import UIKit

extension ConversationListViewController: ThemesViewControllerDelegate {
    
    func themesViewController(_ controller: ThemesViewController, didSelect selectedTheme: UIColor) {
        UINavigationBar.appearance().barTintColor = selectedTheme
        guard let colorData =  try? NSKeyedArchiver.archivedData(withRootObject: selectedTheme, requiringSecureCoding: false) else { return }
        UserDefaults.standard.set(colorData, forKey: "Theme")
        Logger.shared.logThemeChanged(selectedTheme: selectedTheme)
    }
    
}
