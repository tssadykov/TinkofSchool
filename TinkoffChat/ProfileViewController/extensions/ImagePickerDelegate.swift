//
//  ImagePickerDelegate.swift
//  TinkoffChat
//
//  Created by Тимур on 27.09.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPhoto = info[.originalImage] as? UIImage else { return }
        avatarOfUserImageView.image = userPhoto
        isPhotoSelected = true
        dismiss(animated: true, completion: nil)
        handleEnablingSaveButtons()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
