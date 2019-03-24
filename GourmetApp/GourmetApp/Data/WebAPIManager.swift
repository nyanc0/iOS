//
//  WebAPIManager.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/03/24.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import RxSwift

struct WebAPIManager {
    
    public static func call<T,V>(_ request: T, _ disposeBag: DisposeBag, onSuccess: @escaping (V) -> Void, onError: @escaping (Error) -> Void)
        where T: BaseRequestProtocol, V: Codable, T.ResponseType == V{
            _ = observe(request)
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { onSuccess($0) },
                           onError: { onError($0) })
                .disposed(by: disposeBag)
    }
    
    public static func observe<T, V>(_ request: T) -> Single<V> where T: BaseRequestProtocol, V: Codable, T.ResponseType == V {
        return Single<V>.create { observer in
            callForData(request) { outputs in
                switch outputs {
                case .success(let result): observer(.success(result as! V))
                case .failure(let error): observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    /// URLSessionを呼び出して通信を実施する.
    /// - parameter request: extends BaseRequestProtocol
    /// - parameter block: Callback APIResult
    private static func callForData<T, V>(_ request: T, _ block: @escaping (APIResult) -> Void) where T: BaseRequestProtocol , V: Codable, T.ResponseType == V {
        let urlRequest = self.createURLRequest(request)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
            let outputs = self.createOutputs(data: data, urlResponse: urlResponse as? HTTPURLResponse, error: error)
            switch outputs {
            case let .noResponse(errorResponse):
                block(.failure(errorResponse))
            case let .hasResponse(response):
                switch response.statusCode {
                case .ok:
                    let decodeResponse = decodeData(request, response: response)
                    block(decodeResponse)
                default:
                    block(.failure(ErrorResponse(dataContents: "\(response.statusCode)")))
                }
            }
        }
        task.resume()
    }
    
    /// BaseRequestProtocolからURLRequestを作成する.
    /// - parameter input: extends BaseRequestProtocol
    /// - returns: URLRequest
    private static func createURLRequest<T>(_ input: T) -> URLRequest where T: BaseRequestProtocol {
        var request = URLRequest(url: input.baseURL)
        request.httpMethod = input.methodAndPayload.method
        request.httpBody = input.methodAndPayload.body
        return request
    }
    
    /// URLSessionの結果をOutputsに変換する.
    static private func createOutputs(data: Data?, urlResponse: HTTPURLResponse?, error: Error?) -> Outputs {
        guard let data = data, let response = urlResponse else {
            return .noResponse(ErrorResponse(dataContents: error.debugDescription))
        }
        var headers: [String: String] = [:]
        for (key, value) in response.allHeaderFields.enumerated() {
            headers[key.description] = String(describing: value)
        }
        
        return .hasResponse((
            statusCode: .from(code: response.statusCode),
            headers: headers,
            payload: data
        ))
    }
    
    /// JSONのデコード
    private static func decodeData<T, V>(_ request: T, response: APIResponse) -> APIResult where T: BaseRequestProtocol, V: Codable, T.ResponseType == V {
        let jsonDecoder = JSONDecoder()
        do {
            let result = try jsonDecoder.decode(V.self, from: response.payload)
            return .success(result)
        } catch {
            return .failure(ErrorResponse(dataContents: String(data: response.payload , encoding: .utf8)))
        }
    }
}
