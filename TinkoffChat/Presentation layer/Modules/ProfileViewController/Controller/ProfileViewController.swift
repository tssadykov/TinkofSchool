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
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionOfUserTextField: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var scrollView: UIScrollView!
    var profileInteractor: IProfileInteractor!
    var assembly: IPresentationAssembly!
    var isPhotoSelected: Bool = false
    var isSaving: Bool = false
    var isEdit: Bool = false {
        didSet {
            cameraIconView.isHidden = !cameraIconView.isHidden
            nameTextField.isHidden = !nameTextField.isHidden
            saveButton.isHidden = !saveButton.isHidden
            descriptionOfUserTextField.isHidden = !descriptionOfUserTextField.isHidden
            if isEdit {
                saveButton.isEnabled = false
                editProfileButton.setTitle("Отменить редактирование", for: .normal)
                attributesOfNameLabel[.font] = UIFont(name: "Helvetica", size: 17)!
                attributesOfNameLabel[.foregroundColor] = UIColor.lightGray
                attributesOfDescriptionLabel[.font] = UIFont(name: "Helvetica", size: 17)!
                nameOfUserLabel.attributedText = NSAttributedString(string: "Имя пользователя",
                                                                    attributes: attributesOfNameLabel)
                descriptionOfUserLabel.attributedText = NSAttributedString(string: "О себе",
                                                                           attributes: attributesOfDescriptionLabel)
                nameTextField.text = profileInteractor.name
                descriptionOfUserTextField.text = profileInteractor.description
            } else {
                attributesOfNameLabel[.font] = UIFont(name: "Helvetica", size: 27)!
                attributesOfNameLabel[.foregroundColor] = UIColor.black
                attributesOfDescriptionLabel[.font] = UIFont(name: "Helvetica", size: 27)!
                editProfileButton.setTitle("Редактировать", for: .normal)
                updateUI()
            }
        }
    }

    var attributesOfNameLabel: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Helvetica",
                                                                              size: 27)!,
                                                                .foregroundColor: UIColor.black]
    var attributesOfDescriptionLabel: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Helvetica",
                                                                                     size: 27)!,
                                                                       .foregroundColor: UIColor.lightGray]

    // MARK: - Life Cycle ViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(gesture:)))
        view.addGestureRecognizer(tapGesture)
        loadProfile()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setupViews()
    }

    // MARK: - User Activity

    @IBAction func cameraIconTapped(_ sender: UITapGestureRecognizer) {

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let photoPickerAlertController = UIAlertController(title: "Загрузить фотографию",
                                                           message: nil, preferredStyle: .actionSheet)
        let cancelAlertAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        photoPickerAlertController.addAction(cancelAlertAction)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let titleOfAction = "Выбрать из библиотеки"
            let photoLibraryAlertAction = UIAlertAction(title: titleOfAction, style: .default) { [weak self] _ in
                guard let `self` = self else { return }
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            photoPickerAlertController.addAction(photoLibraryAlertAction)
        }

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAlertAction = UIAlertAction(title: "Сделать фото", style: .default) { [weak self] _ in
                guard let `self` = self else { return }
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            photoPickerAlertController.addAction(cameraAlertAction)
        }

        let downloadImageAlertAction = UIAlertAction(title: "Загрузить изображение", style: .default) { (_) in
            self.performSegue(withIdentifier: "DownloadImagesSegue", sender: nil)
        }
        photoPickerAlertController.addAction(downloadImageAlertAction)

        if isPhotoSelected {
            let deleteAlertAction = UIAlertAction(title: "Удалить фотографию", style: .destructive) { [weak self] _ in
                guard let `self` = self else { return }
                self.avatarOfUserImageView.image = UIImage(named: "placeholder-user")
                self.isPhotoSelected = false
                self.handleEnablingSaveButtons()
            }
            photoPickerAlertController.addAction(deleteAlertAction)
        }

        present(photoPickerAlertController, animated: true, completion: nil)
    }

    @IBAction func editButtonTapped(_ sender: UIButton) {
        isEdit = !isEdit
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveProfile()
    }

    @IBAction func nameTextChanged(_ sender: UITextField) {
        handleEnablingSaveButtons()
    }

    @IBAction func descriptionTextChanged(_ sender: UITextField) {
        handleEnablingSaveButtons()
    }

    // MARK: - Private functions
    private func setupViews() {
        avatarOfUserImageView.layer.cornerRadius = cameraIconView.frame.width*0.5
        avatarOfUserImageView.clipsToBounds = true

        cameraIconView.layer.cornerRadius = cameraIconView.frame.width*0.5
        cameraIconView.clipsToBounds = true

        editProfileButton.layer.cornerRadius = 10
        editProfileButton.layer.borderColor = UIColor.black.cgColor
        editProfileButton.layer.borderWidth = 2.0
        editProfileButton.clipsToBounds = true

        saveButton.layer.cornerRadius = 10
        saveButton.layer.borderColor = UIColor.black.cgColor
        saveButton.layer.borderWidth = 2.0
        saveButton.clipsToBounds = true
    }

    func handleEnablingSaveButtons() {
        saveButton.isEnabled = !isSaving && (nameTextField.text != "")
            && ((nameTextField.text != profileInteractor.name)
            || (descriptionOfUserTextField.text != profileInteractor.description)
            || (avatarOfUserImageView.image!.jpegData(compressionQuality: 1.0)
                != profileInteractor.imageData))
    }

    @objc func hideKeyboard(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    private func loadProfile() {
        editProfileButton.isHidden = true
        activityIndicator.startAnimating()
        registerNotifications()
        profileInteractor.loadProfile {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.editProfileButton.isHidden = false
            self.isPhotoSelected = UIImage(named: "placeholder-user")!.jpegData(compressionQuality: 1.0)
                != self.profileInteractor.imageData
            self.updateUI()
        }
    }

    private func updateUI() {
        nameOfUserLabel.attributedText = NSAttributedString(string: profileInteractor.name,
                                                            attributes: attributesOfNameLabel)
        descriptionOfUserLabel.attributedText = NSAttributedString(string: profileInteractor.description,
                                                                   attributes: attributesOfDescriptionLabel)
        avatarOfUserImageView.image = UIImage(data: profileInteractor.imageData)
    }

    private func saveProfile() {
        guard let name = nameTextField.text, let description = descriptionOfUserTextField.text,
            let image = avatarOfUserImageView.image else { return }
        isSaving = true
        saveButton.isEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        profileInteractor.saveProfile(name: name,
                                      description: description,
                                      imageData: image.jpegData(compressionQuality: 1.0)!) { (error) in
            if error == nil {
                let alert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ок", style: .default) { _ in
                    if self.isEdit {
                        self.isEdit = false
                    } else {
                        UserDefaults.standard.set(name, forKey: "name")
                        self.updateUI()
                    }
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Ошибка",
                                              message: "Не удалось сохранить данные", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
                let repeatAction = UIAlertAction(title: "Повтор", style: .default) { _ in
                    self.saveProfile()
                }
                alert.addAction(okAction)
                alert.addAction(repeatAction)
                self.present(alert, animated: true, completion: nil)
            }

            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.saveButton.isEnabled = true
            self.isSaving = false
        }
    }

    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWiilHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWasShown(_ notification: NSNotification) {
        guard let info = notification.userInfo,
            let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
            else { return }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        let keyboardInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = keyboardInsets
        scrollView.scrollIndicatorInsets = keyboardInsets
    }

    @objc private func keyboardWiilHidden() {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}
