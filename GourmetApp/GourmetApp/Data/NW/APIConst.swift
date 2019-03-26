//
//  API.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/03/23.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import RxSwift

protocol BaseAPIProtocol {
    associatedtype ResponseType
    var methodAndPayload: HTTPMethodAndPayload { get }
    var path: String { get }
    var baseURL: URL { get }
}

extension BaseAPIProtocol {
    var baseURL: URL {
        return URL(string: "http://localhost:3000/")!
    }
}

protocol BaseRequestProtocol: BaseAPIProtocol {
    var queries: [URLQueryItem] {get}
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

typealias APIResponse = (
    statusCode: HTTPStatus,
    headers: [String: String],
    payload: Data
)

enum APIResult {
    case success(Codable)
    case failure(Error)
}

struct ErrorResponse: Error, CustomStringConvertible {
    let description: String = "-- Decode Error --"
    var dataContents: String?
}

enum Outputs {
    case hasResponse(APIResponse)
    case noResponse(ErrorResponse)
}
