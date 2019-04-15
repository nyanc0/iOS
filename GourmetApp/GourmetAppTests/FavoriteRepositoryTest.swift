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
    var multipleJson: NSData?

    override func setUp() {
        super.setUp()
        favoriteRepository = FavoriteRepositoryImpl(recipeListRepository: RecipeListRepositoryImpl())

        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.url(forResource: "RecipeResult", withExtension: "json")
        multipleJson = try? NSData(contentsOf: path!, options: .uncached)
    }

    func testGetFavoriteList() {
        self.stub(uri("http://localhost:3000/recipe?recipe_id=001&recipe_id=002"), jsonData(multipleJson! as Data, status: 200))

        _ = FavoriteDao.favoriteDao.addOrUpdate(recipeId: "001")
        _ = FavoriteDao.favoriteDao.addOrUpdate(recipeId: "002")

        do {
            let result: [Recipe] = try favoriteRepository.getFavoriteList().toBlocking().single()
            // 1つ目のレシピ
            XCTAssertEqual(result[0].recipeId, "001")
            XCTAssertEqual(result[0].recipeName, "洋食屋さんのハンバーグ")
            XCTAssertEqual(result[0].cookingIngredients[0].material, "合いびき肉")
            XCTAssertEqual(result[0].cookingMethod[0].procedure, "玉ねぎはみじん切りにし、●以外の材料すべてをボウルに入れて手でよくこねる。")
            // 2つ目のレシピ
            XCTAssertEqual(result[1].recipeId, "002")
            XCTAssertEqual(result[1].recipeName, "基本の豚の角煮")
            XCTAssertEqual(result[1].cookingIngredients[0].material, "●豚バラ肉")
            XCTAssertEqual(result[1].cookingMethod[0].procedure, "鍋に●の材料すべてと、水をいれます。水の量は、材料がすべてかくれるくらい。豚は、かたまりのままです。")
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
}
