//
//  LoaderImageInteractor.swift
//  TinkoffChat
//
//  Created by Тимур on 22/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

protocol IImageLoaderInteractor: class {
    var delegate: ImageLoaderDelegate? { get set }
    var imageRequestsStorage: IImageRequestsStorage? { get set }
    func loadImageURLs()
    func uploadImage(url: URL, completionImageHandler: @escaping (Data?) -> Void)
}

protocol ImageLoaderDelegate: class {
    func updateImages()
    func handleEror()
}

class ImageLoaderInteractor: IImageLoaderInteractor, NetworkManagerDelegate {

    weak var delegate: ImageLoaderDelegate?
    var imageRequestsStorage: IImageRequestsStorage?
    var imageDownloadManager: IImageDownloadManager
    private var networkManager: NetworkManager<ImageRequestsStorageParser, ImageLoaderInteractor>

    init(networkManager: NetworkManager<ImageRequestsStorageParser,
        ImageLoaderInteractor>,
         imageDownloadManager: IImageDownloadManager) {
        self.imageDownloadManager = imageDownloadManager
        self.networkManager = networkManager
        self.networkManager.delegate = self
    }

    func loadImageURLs() {
        networkManager.send()
    }

    func uploadImage(url: URL, completionImageHandler: @escaping (Data?) -> Void) {
        imageDownloadManager.send(url: url, completionImageHandler: completionImageHandler)
    }

    func modelDidLoad(model: ImageRequestsStorage) {
        self.imageRequestsStorage = model
        DispatchQueue.main.async {
            self.delegate?.updateImages()
        }
    }

    func handleError(description: String) {
        DispatchQueue.main.async {
            self.delegate?.handleEror()
        }
    }
}
