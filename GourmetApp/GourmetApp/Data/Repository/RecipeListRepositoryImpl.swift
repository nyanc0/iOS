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

        var queries: [URLQueryItem]

        init(queries: [URLQueryItem]) {
            self.queries = queries
        }
        var methodAndPayload: HTTPMethodAndPayload {
            return HTTPMethodAndPayload.get
        }
        var path: String {
            return "recipe"
        }
    }

    func getRecipeList() -> Single<[Recipe]> {
        return WebAPIManager.observe(RecipeListRequest.init(queries: []))
    }

    func getRecipeList(recipeIds: [String]) -> Single<[Recipe]> {
        // idが指定されていないときは空を返す.
        if recipeIds.isEmpty {
            return Single<[Recipe]>.create { observer in
                observer(.success([]))
                return Disposables.create()
            }
        }
        let queries = recipeIds.map { id in
            URLQueryItem(name: "recipe_id", value: id)
        }
        return WebAPIManager.observe(RecipeListRequest.init(queries: queries))
    }
}
