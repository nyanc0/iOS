//
//  RecipeAPI.swift
//  GourmetApp
//
//  Created by 福岡　侑里奈 on 2019/03/22.
//  Copyright © 2019 yurina fukuoka. All rights reserved.
//

import Foundation
class RecipeAPI{
//    func from(response: Response) -> Either<TransformError, Recipe> {
//        switch response.statusCode {
//        case .ok:
//            guard let string = String(data: response.payload, encoding: .utf8) else {
//                return .left(.malformedData(debugInfo: "not UTF-8 string"))
//            }
//            return .right(Recipe(genreCd: string))
//        default:
//            return .left(.unexpectedStatusCode(
//                debugInfo: "\(response.statusCode)"
//                )
//            )
//        }
//    }
//
//    func fetch(_ block: @escaping (Either<Either<ConnectionError, TransformError>, Recipe>) -> Void) {
//        // 不正なURL
//        let urlString = "https://api.github.com/hoge"
//        guard let url = URL(string: urlString) else {
//            block(.left(.left(.malformedURL(debugInfo: urlString))))
//            return
//        }
//
//        let input: Input = (
//            url: url,
//            queries: [],
//            headers: [:],
//            methodAndPayload: .get
//        )
//
//        WebAPI.call(with: input) { output in
//            switch output {
//            case let .noResponse(connectionError):
//                block(.left(.left(connectionError)))
//            case let .hasResponse(response):
//                let errorOrSuccess = RecipeAPI.init().from(response: response)
//                switch errorOrSuccess {
//                case let .left(error):
//                    block(.left(.right(error)))
//                case let .right(recipe):
//                    block(.right(recipe))
//                }
//            }
//        }
//    }
}
