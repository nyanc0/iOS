//
//  DetailUseCaseTest.swift
//  GourmetAppTests
//
//  Created by yurina fukuoka on 2019/05/06.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import Mockingjay
import RxTest
import RxBlocking

@testable import GourmetApp
class DetailUseCaseTest: XCTestCase {

    var detailUseCase: DetailUseCase!

    override func setUp() {
        detailUseCase = DetailUseCase(favoriteRepository: FavoriteRepositoryImpl(recipeListRepository: RecipeListRepositoryImpl()), recipeDetailRepository: RecipeDetailRepositoryImpl())
    }

    func testSaveRecipe() {
        do {
            _ = FavoriteDao.favoriteDao.deleteAll()
            let saveResult = try detailUseCase.saveRecipe(recipe: createRecipe()).toBlocking().single()
            let savedData = try FavoriteDao.favoriteDao.findById(key: "002").toBlocking().single()
            XCTAssert(saveResult)
            if savedData != nil {
                XCTAssertEqual(savedData!.recipeId, "002")
            } else {
                XCTFail("Result is Nil")
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDeleteRecipe() {
        do {
            _ = FavoriteDao.favoriteDao.deleteAll()
            _ = try detailUseCase.saveRecipe(recipe: createRecipe()).toBlocking().single()
            let deleteResult = try detailUseCase.deleteRecipe(recipe: createRecipe()).toBlocking().single()
            XCTAssert(deleteResult)
            let savedData = try FavoriteDao.favoriteDao.findById(key: "002").toBlocking().single()
            XCTAssert(savedData == nil)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testIsSaved() {
        do {
            _ = FavoriteDao.favoriteDao.deleteAll()
            _ = try detailUseCase.saveRecipe(recipe: createRecipe()).toBlocking().single()
            let isSaved = try detailUseCase.checkRecipeSaved(recipeId: "002").toBlocking().single()
            XCTAssert(isSaved)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testIsNotSaved() {
        do {
            _ = FavoriteDao.favoriteDao.deleteAll()
            _ = try detailUseCase.saveRecipe(recipe: createRecipe()).toBlocking().single()
            let isSaved = try detailUseCase.checkRecipeSaved(recipeId: "001").toBlocking().single()
            XCTAssert(!isSaved)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    private func createRecipe() -> Recipe {
        let cookingIngredients: [CookingIngredients] = [ CookingIngredients(material: "卵", quantity: "1"),
                                                         CookingIngredients(material: "ひき肉", quantity: "100g")
        ]

        let cookingMethod: [CookingMethod] = [
            CookingMethod(procedureNo: "1", procedure: "よくこねる")
        ]

        return Recipe(
            genreCd: "G001",
            genreName: "お肉のおかず",
            recipeId: "002",
            recipeName: "洋食屋さんのハンバーグ",
            introduction: "おすすめのレシピ",
            mainUrl: "hogehoge",
            recommendedFlg: "0",
            cookingIngredients: cookingIngredients,
            cookingMethod: cookingMethod
        )
    }

}
