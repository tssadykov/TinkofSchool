//
//  ThemesViewController.swift
//  TinkoffChat
//
//  Created by Тимур on 13/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit

typealias ColorChangedHandler = (UIColor) -> Void
class ThemesViewController: UIViewController {

    @IBOutlet var themesButtons: [UIButton]!
    
    private let model: Themes = Themes()
    var colorHandler: ColorChangedHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func themeButtonTapped(_ sender: UIButton) {
        //.indexof
        if sender == themesButtons[0] {
            colorHandler(model.theme1)
            navigationController?.navigationBar.barTintColor = model.theme1
        } else if sender == themesButtons[1] {
            colorHandler(model.theme2)
            navigationController?.navigationBar.barTintColor = model.theme2
        } else {
            colorHandler(model.theme3)
            navigationController?.navigationBar.barTintColor = model.theme3
        }
    }
    
    deinit {
        print("DEINIT")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
