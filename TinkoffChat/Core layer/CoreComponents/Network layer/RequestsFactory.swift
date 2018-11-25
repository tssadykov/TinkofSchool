//
//  RequestsFactory.swift
//  TinkoffChat
//
//  Created by Тимур on 22/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

struct RequestsFactory {
    struct ImageLoaderFactory {
        static func imageDownloaderConfig() -> RequestConfig<ImageRequestsStorageParser> {
            return RequestConfig<ImageRequestsStorageParser>(request:
                PixabayRequest(apiKey: "10775117-3ca4fced431dda046ab116e20"),
                                                        parser: ImageRequestsStorageParser())
        }
    }
}
