//
//  Recipe.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/03/20.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
struct Recipe {
    let genreCd: String
    let genreName: String
    let recipeId: String
    let recipeName: String
    let introduction: String
    let mainUrl: String
    let recommendedFlg: Int
    let cookingIngredients: CookingIngredients
    let cookingMethod: CookingMethod
}