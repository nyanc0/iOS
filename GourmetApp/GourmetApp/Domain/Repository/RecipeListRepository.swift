//
//  RecipeListRepository.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/03/24.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import RxSwift
protocol RecipeListRepository {
    func getRecipeList() -> Single<[Recipe]>
    func getRecipeList(recipeIds: [String]) -> Single<[Recipe]>
    func getRecipeList(reccomendFlg: String) -> Single<[Recipe]>
}
