//
//  DownloadImage.swift
//  TinkoffChat
//
//  Created by Тимур on 22/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

protocol IDownloadImage {
    var image: UIImage { get }
}

struct DownloadImage: Codable, IDownloadImage {
    var image: UIImage

    enum CodingKeys: String, CodingKey {
        case image = "imageURL"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(Data.self, forKey: .image)
        guard let image = UIImage(data: data) else { throw NSError() }
        self.image = image
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        guard let data = image.jpegData(compressionQuality: 1.0) else { throw NSError() }
        try container.encode(data, forKey: .image)
    }
}
