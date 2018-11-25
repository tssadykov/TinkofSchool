//
//  Requests.swift
//  TinkoffChat
//
//  Created by Тимур on 23/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

struct PixabayRequest: IRequest {
    var urlRequest: URLRequest?

    init(apiKey: String) {
        var urlString = "https://pixabay.com/api/"
        urlString += ("?key=" + apiKey)
        let url = URL(string: urlString)!
        urlRequest = URLRequest(url: url)
        print(url.absoluteString)
    }
}
