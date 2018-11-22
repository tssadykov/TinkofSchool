//
//  RequestConfig.swift
//  TinkoffChat
//
//  Created by Тимур on 22/11/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import Foundation

protocol IRequest {
    var urlRequest: URLRequest? { get }
}

protocol IParser {
    associatedtype Model
    func parse(data: Data) -> Model?
}

enum RequestResult<T> {
    case succes(T)
    case error(String)
}

struct RequestConfig<Parser: IParser> {
    var request: IRequest
    var parser: Parser
}
