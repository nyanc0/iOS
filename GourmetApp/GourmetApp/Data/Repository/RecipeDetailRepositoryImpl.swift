//
//  RecipeDetailRepositoryImpl.swift
//  GourmetApp
//
//  Created by 福岡　侑里奈 on 2019/03/25.
//  Copyright © 2019 yurina fukuoka. All rights reserved.
//

import Foundation
import RxSwift

class RecipeDetailRepositoryImpl: RecipeDetailRepository {
    func getRecipeDetail(_ recipeId: String) -> Single<[Recipe]> {
        return WebAPIManager
            .observe(RecipeDetailRequest(recipeId: recipeId))
    }
}

struct RecipeDetailRequest: BaseRequestProtocol {

    typealias ResponseType = [Recipe]
    var recipeId: String?

    init(recipeId: String) {
        self.recipeId = recipeId
    }

    var methodAndPayload: HTTPMethodAndPayload {
        return HTTPMethodAndPayload.get
    }
    var path: String {
        return "recipe"
    }
    var queries: [URLQueryItem] {
        return [URLQueryItem(name: "recipe_id", value: recipeId)]
    }
}
