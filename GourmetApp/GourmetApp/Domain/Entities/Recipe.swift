//
//  Recipe.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/03/20.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.

import Foundation
struct Recipe : Codable {
    let genreCd: String
    let genreName: String
    let recipeId: String
    let recipeName: String
    let introduction: String
    let mainUrl: String
    let recommendedFlg: Int
    let cookingIngredients: [CookingIngredients]
    let cookingMethod: [CookingMethod]
    
    private enum CodingKeys: String, CodingKey {
        case genreCd = "genre_cd"
        case genreName = "genre_name"
        case recipeId = "recipe_id"
        case recipeName = "recipe_name"
        case introduction = "introduction"
        case mainUrl = "main_gazo"
        case recommendedFlg = "recommended_flg"
        case cookingIngredients = "cooking_ingredients"
        case cookingMethod = "cooking_method"
    }
}
