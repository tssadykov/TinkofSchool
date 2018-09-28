//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Тимур on 20.09.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var avatarOfUserImageView: UIImageView!
    @IBOutlet weak var nameOfUserLabel: UILabel!
    @IBOutlet weak var descriptionOfUserLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var cameraIconView: UIView!
    
    var isPhotoSelected: Bool = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        //print(editProfileButton.frame)
        //frame в init не доступен, так как view ещё не загрузилась
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //print(editProfileButton.frame)
        //frame в init не доступен, так как view ещё не загрузилась
    }
    
    // MARK: - Life Cycle ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        print(editProfileButton.frame) // frame с размерами из Storyboard
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLayoutSubviews()
        
        print(editProfileButton.frame) // frame с размерами после выполнения Auto layout
    }

    //MARK: - User Activity
    
    @IBAction func cameraIconTapped(_ sender: UITapGestureRecognizer) {
        print("Выбери изображение профиля")
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let photoPickerAlertController = UIAlertController(title: "Загрузить фотографию", message: nil, preferredStyle: .actionSheet)
        let cancelAlertAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        photoPickerAlertController.addAction(cancelAlertAction)
        
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAlertAction = UIAlertAction(title: "Выбрать из библиотеки", style: .default) { [weak self] action in
                guard let `self` = self else { return }
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            photoPickerAlertController.addAction(photoLibraryAlertAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAlertAction = UIAlertAction(title: "Сделать фото", style: .default) { [weak self] action in
                guard let `self` = self else { return }
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            photoPickerAlertController.addAction(cameraAlertAction)
        }
        
        if isPhotoSelected {
            let deleteAlertAction = UIAlertAction(title: "Удалить фотографию", style: .destructive) { [weak self] action in
                guard let `self` = self else { return }
                self.avatarOfUserImageView.image = UIImage(named: "placeholder-user")
                self.isPhotoSelected = false
            }
            photoPickerAlertController.addAction(deleteAlertAction)
        }
        
        present(photoPickerAlertController, animated: true, completion: nil)
    }
    
    //MARK: - Private functions
    private func setupViews(){
        avatarOfUserImageView.layer.cornerRadius = 35
        avatarOfUserImageView.clipsToBounds = true
        
        cameraIconView.layer.cornerRadius = 35
        cameraIconView.clipsToBounds = true
        
        editProfileButton.layer.cornerRadius = 10
        editProfileButton.layer.borderColor = UIColor.black.cgColor
        editProfileButton.layer.borderWidth = 2.0
        editProfileButton.clipsToBounds = true
    }
}
