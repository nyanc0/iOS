//
//  RecipeListRepositoryImpl.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/03/24.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import RxSwift
class RecipeListRepositoryImpl: RecipeListRepository {
     struct RecipeListRequest: BaseRequestProtocol {
        typealias ResponseType = [Recipe]
        var methodAndPayload: HTTPMethodAndPayload {
            return HTTPMethodAndPayload.get
        }
        var path: String {
            return "recipe"
        }
        var queries: [URLQueryItem] {
            return []
        }
    }
    func getRecipeList() -> Single<[Recipe]> {
        return WebAPIManager.observe(RecipeListRequest())
    }
}
