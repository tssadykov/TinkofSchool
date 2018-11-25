//
//  LoadImageVC+CVDelegate.swift
//  TinkoffChat
//
//  Created by Тимур on 22/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

extension LoaderImageViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DownloadImageCollectionViewCell else { return }
        if cell.imageUpload {
            performSegue(withIdentifier: "UnwindToProfile", sender: cell.downloadImage.image)
        } else {
            collectionView.reloadItems(at: [indexPath])
        }
    }
}
