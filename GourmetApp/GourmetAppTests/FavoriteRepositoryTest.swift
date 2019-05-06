//
//  FavoriteRepositoryTest.swift
//  GourmetAppTests
//
//  Created by yurina fukuoka on 2019/03/28.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import Mockingjay
import RxTest
import RxBlocking

@testable import GourmetApp
class FavoriteRepositoryTest: XCTestCase {

    var favoriteRepository: FavoriteRepository!
    //    var multipleJson: NSData?

    override func setUp() {
        super.setUp()
        favoriteRepository = FavoriteRepositoryImpl(recipeListRepository: RecipeListRepositoryImpl())
    }

    func testGetFavoriteList() {
        _ = FavoriteDao.favoriteDao.deleteAll()
        _ = FavoriteDao.favoriteDao.addOrUpdate(recipeId: "002")

        do {
            let result: [Recipe] = try favoriteRepository.getFavoriteList().toBlocking().single()
            XCTAssertEqual(result[0].recipeId, "002")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testGetNilFavoriteList() {
        do {
            _ = FavoriteDao.favoriteDao.deleteAll()
            let result: [Recipe] = try favoriteRepository.getFavoriteList().toBlocking().single()
            XCTAssert(result.isEmpty)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testInsertRecipe() {
        do {
            _ = FavoriteDao.favoriteDao.deleteAll()
            _ = try favoriteRepository.insert(recipe: createRecipe()).toBlocking().single()
            let searchResult = try FavoriteDao.favoriteDao.findById(key: "002").toBlocking().single()
            if searchResult != nil {
                XCTAssertEqual(searchResult?.recipeId, "002")
            } else {
                XCTFail("Result is Nil")
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testIsSaved() {
        do {
            _ = FavoriteDao.favoriteDao.deleteAll()
            _ = try favoriteRepository.insert(recipe: createRecipe()).toBlocking().single()
            let result = try favoriteRepository.isRecipeSaved(recipeId: "002").toBlocking().single()
            XCTAssert(result)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testIsNotSaved() {
        do {
            _ = FavoriteDao.favoriteDao.deleteAll()
            _ = try favoriteRepository.insert(recipe: createRecipe()).toBlocking().single()
            let result = try favoriteRepository.isRecipeSaved(recipeId: "001").toBlocking().single()
            XCTAssert(!result)
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
