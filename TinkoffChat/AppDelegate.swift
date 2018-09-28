//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Тимур on 20.09.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let logger = Logger.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
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
        
        logger.printStateLog(#function, to: "\(UIApplication.shared.applicationState)", didMoved: true)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        logger.printStateLog(#function, to: "not running", didMoved: false)
    }


}

