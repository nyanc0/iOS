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

    /// 全件取得
    /// - returns: Single<[Recipe]>
    func getRecipeList() -> Single<[Recipe]> {
        return WebAPIManager.observe(RecipeListRequest(queries: []))
    }

    /// ID指定
    /// - parameter recipeIds: 検索するレシピIDの配列
    /// - returns: Single<[Recipe]>
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
        return WebAPIManager.observe(RecipeListRequest(queries: queries))
    }

    /// オススメレシピ取得
    /// - parameter reccomendFlg: オススメフラグ(0 or 1)
    /// - returns: Single<[Recipe]>
    func getRecipeList(reccomendFlg: String) -> Single<[Recipe]> {
        let queries: URLQueryItem
        if reccomendFlg.isEmpty {
            // 指定がない場合はオススメレシピを取得する
            queries = URLQueryItem(name: "recommended_flg", value: "1")
        } else {
            queries = URLQueryItem(name: "recommended_flg", value: reccomendFlg)
        }
        return WebAPIManager.observe(RecipeListRequest(queries: [queries]))
    }
}

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
