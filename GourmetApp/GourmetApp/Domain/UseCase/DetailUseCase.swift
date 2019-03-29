//
//  DetailUseCase.swift
//  GourmetApp
//
//  Created by 福岡　侑里奈 on 2019/03/29.
//  Copyright © 2019 yurina fukuoka. All rights reserved.
//

import Foundation
import RxSwift
class DetailUseCase {
    private let favoriteRepository: FavoriteRepository
    private let recipeDetailRepository: RecipeDetailRepository
    
    init(favoriteRepository: FavoriteRepository, recipeDetailRepository: RecipeDetailRepository) {
        self.favoriteRepository = favoriteRepository
        self.recipeDetailRepository = recipeDetailRepository
    }
    
    func loadDetail(recipeId: String) -> Single<Recipe?> {
        return recipeDetailRepository.getRecipeDetail(recipeId)
    }
    
    func saveRecipe(recipe: Recipe) -> Single<Bool> {
        return favoriteRepository.insert(recipe: recipe)
    }
    
    func deleteRecipe(recipe: Recipe) -> Single<Bool> {
        return favoriteRepository.delete(recipe:recipe)
    }
}
