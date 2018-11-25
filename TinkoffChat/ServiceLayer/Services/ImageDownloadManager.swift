//
//  ImageDownloadManager.swift
//  TinkoffChat
//
//  Created by Тимур on 24/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

protocol IImageDownloadManager {
    var imageProvider: IImageProvider { get }
    func send(url: URL, completionImageHandler: @escaping (Data?) -> Void)
}

class ImageDownloadManager: IImageDownloadManager {
    var imageProvider: IImageProvider

    init(imageProvider: IImageProvider) {
        self.imageProvider = imageProvider
    }

    func send(url: URL, completionImageHandler: @escaping (Data?) -> Void) {
        imageProvider.downloadImage(url: url) { (result) in
            switch result {
            case .succes(let data):
                completionImageHandler(data)
            case .error:
                completionImageHandler(nil)
            }
        }
    }
}
