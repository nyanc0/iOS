//
//  RecipeRepository.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/03/21.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import RxSwift
protocol RecipeDetailRepository {
    //    func getRecipeDetail(_ recipeId: String) -> Single<Recipe?>
    func getRecipeDetail(_ recipeId: String) -> Single<[Recipe]>
}
