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

    var stringOfPreviousState: String = "not running"
    
    func printStateLog(_ functionName: String, from firstStatement: String, to secondStatement: String, didMoved: Bool){
        #if DEBUG
        if didMoved {
            print("Application moved from \(firstStatement) to \(secondStatement): \(functionName)")
        } else {
            print("Application will move from \(firstStatement) to \(secondStatement): \(functionName)")
        }
        stringOfPreviousState = secondStatement
        #endif
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        printStateLog(#function, from: stringOfPreviousState, to: "\(UIApplication.shared.applicationState)", didMoved: true)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        printStateLog(#function, from: "\(UIApplication.shared.applicationState)", to: "inactive", didMoved: false)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        printStateLog(#function, from: stringOfPreviousState, to: "\(UIApplication.shared.applicationState)", didMoved: true)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        printStateLog(#function, from: "\(UIApplication.shared.applicationState)", to: "inactive", didMoved: false)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        printStateLog(#function, from: stringOfPreviousState, to: "\(UIApplication.shared.applicationState)", didMoved: true)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        printStateLog(#function, from: "\(UIApplication.shared.applicationState)", to: "not running", didMoved: false)
    }


}

