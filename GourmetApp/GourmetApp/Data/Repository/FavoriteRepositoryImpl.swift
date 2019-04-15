//
//  FavoriteRepositoryImpl.swift
//  GourmetApp
//
//  Created by 福岡　侑里奈 on 2019/03/28.
//  Copyright © 2019 yurina fukuoka. All rights reserved.
//

import Foundation
import RxSwift
class FavoriteRepositoryImpl: FavoriteRepository {

    let recipeListRepository: RecipeListRepository

    init(recipeListRepository: RecipeListRepository) {
        self.recipeListRepository = recipeListRepository
    }

    func getFavoriteList() -> Single<[Recipe]> {
        return FavoriteDao.favoriteDao.findAll()
            .map { results in
                results.map { favoriteModel in
                    favoriteModel.recipeId
                }
            }.flatMap { ids in
                self.recipeListRepository.getRecipeList(recipeIds: ids)
        }
    }

    func insert(recipe: Recipe) -> Single<Bool> {
        return Single<Bool>.create { observer in
            if FavoriteDao.favoriteDao.addOrUpdate(recipeId: recipe.recipeId) {
                observer(.success(true))
            } else {
                observer(.error(NSError(domain: "Could not insert record!!", code: -1, userInfo: nil)))
            }
            return Disposables.create()
        }
    }

    func delete(recipe: Recipe) -> Single<Bool> {
        return Single<Bool>.create { observer in
            if FavoriteDao.favoriteDao.delete(key: recipe.recipeId) {
                observer(.success(true))
            } else {
                observer(.error(NSError(domain: "Could not delete record!!", code: -1, userInfo: nil)))
            }
            return Disposables.create()
        }
    }
}
