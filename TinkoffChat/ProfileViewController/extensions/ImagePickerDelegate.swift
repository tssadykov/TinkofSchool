//
//  ImagePickerDelegate.swift
//  TinkoffChat
//
//  Created by Тимур on 27.09.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation
import UIKit

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPhoto = info[.originalImage] as? UIImage else { return }
        if profile.userImage != userPhoto {
            avatarOfUserImageView.image = userPhoto
            gcdButton.isEnabled = true
            operationButton.isEnabled = true
        }
        isPhotoSelected = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
