//
//  RecipeUseCase.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/03/21.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import RxSwift
class RecipeListUseCase {

    private let recipeListRepository: RecipeListRepository

    init(with recipeListRepository: RecipeListRepository) {
        self.recipeListRepository = recipeListRepository
    }

    func loadRecipeList() -> Single<[Recipe]> {
        return recipeListRepository.getRecipeList()
    }
}
