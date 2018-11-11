//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Тимур on 20.09.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let logger = Logger.shared
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let themeData = UserDefaults.standard.value(forKey: "Theme") as? Data,
            let theme = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(themeData) as? UIColor {
            UINavigationBar.appearance().barTintColor = theme
        } else {
            UINavigationBar.appearance().barTintColor = UIColor.green
        }
        logger.printStateLog(#function, to: "\(UIApplication.shared.applicationState)", didMoved: true)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        logger.printStateLog(#function, to: "inactive", didMoved: false)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        logger.printStateLog(#function, to: "\(UIApplication.shared.applicationState)", didMoved: true)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        logger.printStateLog(#function, to: "inactive", didMoved: false)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        CommunicationManager.shared.didStartSessions()
        logger.printStateLog(#function, to: "\(UIApplication.shared.applicationState)", didMoved: true)
    }

    func applicationWillTerminate(_ application: UIApplication) {

        logger.printStateLog(#function, to: "not running", didMoved: false)
    }

}
