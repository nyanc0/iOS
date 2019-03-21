//
//  WebAPI.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/03/21.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation

typealias Input = Request

typealias Request = (
    url: URL,
    queries: [URLQueryItem],
    headers: [String: String],
    methodAndPayload: HTTPMethodAndPayload
)

enum HTTPMethodAndPayload {
    case get

    var method: String {
        switch self {
        case .get:
            return "GET"
        }
    }

    var body: Data? {
        switch self {
        case .get:
            return nil
        }
    }
}

enum WebAPI {
    // ビルドを通すために call 関数を用意しておく。
    static func call(with input: Input) {
    }
}

enum Output {
    case hasResponse(Response)
    case noResponse(ConnectionError)
}

enum ConnectionError {
    case noDataOrNoResponse(debugInfo: String)
}

typealias Response = (
    /// レスポンスの意味をあらわすステータスコード。
    statusCode: HTTPStatus,
    /// HTTP ヘッダー。
    headers: [String: String],
    /// レスポンスの本文。
    payload: Data
)

enum HTTPStatus {
    case oK
    case notFound
    case unsupported(code: Int)
    static func from(code: Int) -> HTTPStatus {
        switch code {
        case 200:
            return .oK
        case 404:
            return .notFound
        default:
            return .unsupported(code: code)
        }
    }
}
