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
    let rootAssembly = RootAssembly()
    var topView: UIView!
    lazy var emitterLayer: CAEmitterLayer = {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterSize = window!.bounds.size
        let emitterCell = CAEmitterCell()
        emitterCell.birthRate = 50
        emitterCell.lifetime = 1
        emitterCell.velocity = 100
        emitterCell.scale = 0.1
        emitterCell.alphaSpeed = 0.1
        emitterCell.emissionRange = CGFloat.pi * 2
        emitterCell.contents = UIImage(named: "tinkoff-flag.png")!.cgImage!
        emitterLayer.emitterCells = [emitterCell]
        return emitterLayer
    }()
    lazy var pressGesture: UILongPressGestureRecognizer = {
        return UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(recognizer:)))
    }()
    var startPoint: CGPoint?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let themeData = UserDefaults.standard.value(forKey: "Theme") as? Data,
            let theme = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(themeData) as? UIColor {
            UINavigationBar.appearance().barTintColor = theme
        } else {
            UINavigationBar.appearance().barTintColor = UIColor.green
        }
        logger.printStateLog(#function, to: "\(UIApplication.shared.applicationState)", didMoved: true)
        guard let rootVC = window?.rootViewController as? UINavigationController,
            let conversationVC = rootVC.topViewController as? ConversationListViewController else { return true }
        conversationVC.assembly = rootAssembly.presentationAssembly
        conversationVC.conversationListInteractor = rootAssembly.presentationAssembly.getConversationListInteractor()
        pressGesture.minimumPressDuration = 0.5
        window?.addGestureRecognizer(pressGesture)
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
        let communicationManager = rootAssembly.presentationAssembly.serviceAssembly.communicationManager
        communicationManager.didStartSessions()
        logger.printStateLog(#function, to: "\(UIApplication.shared.applicationState)", didMoved: true)
    }

    func applicationWillTerminate(_ application: UIApplication) {

        logger.printStateLog(#function, to: "not running", didMoved: false)
    }

    @objc func longPressGesture(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startPoint = recognizer.location(in: window!)
            emitterLayer.emitterPosition = startPoint!
            window!.layer.addSublayer(emitterLayer)
        case .changed:
            emitterLayer.emitterPosition = recognizer.location(in: window!)
        case .ended:
            emitterLayer.removeFromSuperlayer()
        default:
            print("NOT BEGAN")
        }
    }
}
