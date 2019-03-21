//
//  RecipeUseCase.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/03/21.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import RxSwift
class RecipeUseCase {

    private let recipeRepository: RecipeRepository

    init(with recipeRepository: RecipeRepository) {
        self.recipeRepository = recipeRepository
    }

    func loadRecipeList() -> Single<[Recipe]> {
        return recipeRepository.getRecipeList()
    }

    func loadRecipe(with recipeId: String) -> Single<Recipe> {
        return recipeRepository.getRecipeDetail(recipeId)
    }
}
