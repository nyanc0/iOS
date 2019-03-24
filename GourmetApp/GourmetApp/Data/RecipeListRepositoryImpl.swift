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
    
    enum RecipeListRequest: BaseRequestProtocol {
        typealias ResponseType = RecipeResponse
        case get
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
    func getRecipeList() -> Single<RecipeResponse> {
        return WebAPIManager.observe(RecipeListRequest.get)
    }
}
