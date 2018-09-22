//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Тимур on 20.09.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let logger = Logger.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logger.printLog(name: #function)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logger.printLog(name: #function)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        logger.printLog(name: #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logger.printLog(name: #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLayoutSubviews()
        
        logger.printLog(name: #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        logger.printLog(name: #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        logger.printLog(name: #function)
    }
}
