//
//  API.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/03/23.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import RxSwift

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

enum APIPath {
    case recipe
    case genre
    
    public var path: String {
        switch self {
        case .recipe:
            return "recipe"
        case .genre:
            return "genre"
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

protocol BaseRequestProtocol {
    
    associatedtype ResponseType
    
    var url: URL {get}
    var path: APIPath {get}
    var methodAndPayload: HTTPMethodAndPayload {get}
    var queries: [URLQueryItem] {get}
}

extension BaseRequestProtocol {
    var url: URL {
        return URL(string: "http://localhost:3000/")!
    }
    
    func createRequest() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = methodAndPayload.method
        request.httpBody = methodAndPayload.body
        return request
    }
}

enum APIResult {
    case success(Codable)
    case failure(Error)
}

struct ErrorResponse: Error, CustomStringConvertible {
    let description: String = "-- Decode Error --"
    var dataContents: String?
}

enum WebAPIManager {
    static func call<T, V>(_ request: T
        , _ disposeBag: DisposeBag
        , onSuccess: @escaping (V) -> Void
        , onError: @escaping (Error) -> Void)
        where T: BaseRequestProtocol, V: Codable, T.ResponseType == V {
            _ = observe(request)
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { onSuccess($0) },
                           onError: { onError($0) })
                .disposed(by: disposeBag)
    }
    
    private static func observe<T, V>(_ request: T) -> Single<V>
        where T: BaseRequestProtocol, V: Codable, T.ResponseType == V {
            
            return Single<V>.create { observer in
                let urlRequest = request.createRequest()
                let task = URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
                    
                }
                
                
                
                
                let calling = callForData(request) { response in
                    switch response {
                    //※ 既にsuccessしているので「as! V」で強制キャストしている（できる）
                    case .success(let result): observer(.success(result as! V))
                    case .failure(let error): observer(.error(error))
                    }
                }
                
                return Disposables.create() { calling.cancel() }
            }
}
