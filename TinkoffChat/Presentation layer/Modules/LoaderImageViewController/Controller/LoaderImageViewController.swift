//
//  LoaderImageViewController.swift
//  TinkoffChat
//
//  Created by Тимур on 22/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit

class LoaderImageViewController: UIViewController, ImageLoaderDelegate {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    var assembly: IPresentationAssembly!
    var imageLoaderInteractor: IImageLoaderInteractor!
    let space: CGFloat = 15
    let itemsPerRow = 3
    override func viewDidLoad() {
        super.viewDidLoad()

        loadImageList()
    }

    func loadImageList() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        imageLoaderInteractor.loadImageURLs()
    }

    func stopSpinner() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

    func updateImages() {
        stopSpinner()
        collectionView.reloadData()
    }

    func handleEror() {
        stopSpinner()
        let alert = UIAlertController(title: "Не удалось загрузить изображения",
                                      message: "Проверьте интенет соединение",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func closeImageLoader(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "UnwindToProfile", sender: nil)
    }

    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        loadImageList()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindToProfile" {
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first,
            let cell = collectionView.cellForItem(at: indexPath) as? DownloadImageCollectionViewCell,
            let profileVC = segue.destination as? ProfileViewController else { return }
            if cell.imageUpload {
                profileVC.avatarOfUserImageView.image = cell.downloadImage.image
                profileVC.isPhotoSelected = true
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
