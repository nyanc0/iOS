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

enum WebAPI {
    static func call(with input: Input) {
        self.call(with: input) { _ in
            // NOTE: コールバックでは何もしない
        }
    }
    static func call(with input: Input, _ block: @escaping (Output) -> Void) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            let response: Response = (
                statusCode: .ok,
                headers: [:],
                payload: "this is a response text".data(using: .utf8)!
            )
            
            // 仮のレスポンスでコールバックを呼び出す。
            block(.hasResponse(response))
        }
    }
    
    static private func createURLRequest(by input: Input) -> URLRequest {
        var request = URLRequest(url: input.url)
        request.httpMethod = input.methodAndPayload.method
        request.httpBody = input.methodAndPayload.body
        request.allHTTPHeaderFields = input.headers
        return request
    }
}

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

enum Output {
    case hasResponse(Response)
    case noResponse(ConnectionError)
}

enum ConnectionError {
    case noDataOrNoResponse(debugInfo: String)
}

typealias Response = (
    statusCode: HTTPStatus,
    headers: [String: String],
    payload: Data
)

enum HTTPStatus {
    case ok
    case notFound
    case unsupported(code: Int)
    static func from(code: Int) -> HTTPStatus {
        switch code {
        case 200:
            return .ok
        case 404:
            return .notFound
        default:
            return .unsupported(code: code)
        }
    }
}

enum Either<Left, Right> {
    /// Eigher<A, B> の A の方の型。
    case left(Left)
    
    /// Eigher<A, B> の B の方の型。
    case right(Right)
    
    
    /// もし、左側の型ならその値を、右側の型なら nil を返す。
    var left: Left? {
        switch self {
        case let .left(x):
            return x
            
        case .right:
            return nil
        }
    }
    
    /// もし、右側の型ならその値を、左側の型なら nil を返す。
    var right: Right? {
        switch self {
        case .left:
            return nil
            
        case let .right(x):
            return x
        }
    }
}

enum TransformError {
    /// HTTP ステータスコードが OK 以外だった場合のエラー。
    case unexpectedStatusCode(debugInfo: String)
    
    /// ペイロードが壊れた文字列だった場合のエラー。
    case malformedData(debugInfo: String)
}


