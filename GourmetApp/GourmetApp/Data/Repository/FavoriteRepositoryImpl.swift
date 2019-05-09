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

    func insert(recipe: Recipe) -> Bool {
        return FavoriteDao.favoriteDao.addOrUpdate(recipeId: recipe.recipeId)
    }

    func delete(recipe: Recipe) -> Bool {
        return FavoriteDao.favoriteDao.delete(key: recipe.recipeId)
    }

    func isRecipeSaved(recipeId: String) -> Single<Bool> {
        return Single<Bool>.create { observer in
            if FavoriteDao.favoriteDao.isSaved(key: recipeId) {
                observer(.success(true))
            } else {
                observer(.success(false))
            }
            return Disposables.create()
        }
    }
}
