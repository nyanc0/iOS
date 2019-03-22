//
//  RecipeAPI.swift
//  GourmetApp
//
//  Created by 福岡　侑里奈 on 2019/03/22.
//  Copyright © 2019 yurina fukuoka. All rights reserved.
//

import Foundation
class RecipeAPI{
    func from(response: Response) -> Either<TransformError, Recipe> {
        switch response.statusCode {
        case .ok:
            guard let string = String(data: response.payload, encoding: .utf8) else {
                return .left(.malformedData(debugInfo: "not UTF-8 string"))
            }
            return .right(Recipe(genreCd: string))
        default:
            return .left(.unexpectedStatusCode(
                debugInfo: "\(response.statusCode)"
                )
            )
        }
    }
}
