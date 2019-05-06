//
//  RecipeAPITests.swift
//  GourmetAppTests
//
//  Created by 福岡　侑里奈 on 2019/03/22.
//  Copyright © 2019 yurina fukuoka. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import Mockingjay
import RxTest
import RxBlocking
@testable import GourmetApp

class RecipeAPITest: XCTestCase {

    var recipeListRepository: RecipeListRepository!
    var recipeDetailRepository: RecipeDetailRepository!
    var allResult: NSData?
    var multipleJson: NSData?
    var singleResult: NSData?
    var reccomendResult: NSData?

    override func setUp() {
        super.setUp()
        recipeListRepository = RecipeListRepositoryImpl()
        recipeDetailRepository = RecipeDetailRepositoryImpl()

        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.url(forResource: "AllResult", withExtension: "json")
        allResult = try? NSData(contentsOf: path!, options: .uncached)

        let multiplePath = testBundle.url(forResource: "RecipeResult", withExtension: "json")
        multipleJson = try? NSData(contentsOf: multiplePath!, options: .uncached)

        let singlePath = testBundle.url(forResource: "SingleResult", withExtension: "json")
        singleResult = try? NSData(contentsOf: singlePath!, options: .uncached)

        let reccomendPath = testBundle.url(forResource: "ReccomendResult", withExtension: "json")
        reccomendResult = try? NSData(contentsOf: reccomendPath!, options: .uncached)
    }

    func testGetRecipeList() {
        self.stub(uri("http://localhost:3000/recipe?"), jsonData(allResult! as Data, status: 200))
        do {
            let result: [Recipe] = try recipeListRepository.getRecipeList().toBlocking().single()
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

    func testGetRecipeListWithIds() {
        self.stub(uri("http://localhost:3000/recipe?recipe_id=001&recipe_id=002"), jsonData(multipleJson! as Data, status: 200))
        let recipeIds: [String] = ["001", "002"]
        do {
            let result: [Recipe] = try recipeListRepository.getRecipeList(recipeIds: recipeIds).toBlocking().single()
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

    //    func testGetRecipeWithId() {
    //        self.stub(uri("http://localhost:3000/recipe?recipe_id=001"), jsonData(singleResult! as Data, status: 200))
    //        do {
    //            let result: Recipe? = try recipeDetailRepository.getRecipeDetail("001").toBlocking().single()
    //            if result == nil {
    //                XCTFail("Result is Nil")
    //            }
    //            XCTAssertEqual(result!.recipeId, "001")
    //            XCTAssertEqual(result!.recipeName, "洋食屋さんのハンバーグ")
    //            XCTAssertEqual(result!.cookingIngredients[0].material, "合いびき肉")
    //            XCTAssertEqual(result!.cookingMethod[0].procedure, "玉ねぎはみじん切りにし、●以外の材料すべてをボウルに入れて手でよくこねる。")
    //        } catch {
    //            XCTFail(error.localizedDescription)
    //        }
    //    }
    //
    //    func testGetReccomendRecipe() {
    //        self.stub(uri("http://localhost:3000/recipe?recommended_flg=1"), jsonData(reccomendResult! as Data, status: 200))
    //        do {
    //            let result: [Recipe] = try recipeListRepository.getRecipeList(reccomendFlg: "1").toBlocking().single()
    //            // 1つ目のレシピ
    //            XCTAssertEqual(result[0].recipeId, "001")
    //            XCTAssertEqual(result[0].recipeName, "洋食屋さんのハンバーグ")
    //            XCTAssertEqual(result[0].cookingIngredients[0].material, "合いびき肉")
    //            XCTAssertEqual(result[0].cookingMethod[0].procedure, "玉ねぎはみじん切りにし、●以外の材料すべてをボウルに入れて手でよくこねる。")
    //            // 2つ目のレシピ
    //            XCTAssertEqual(result[1].recipeId, "002")
    //            XCTAssertEqual(result[1].recipeName, "基本の豚の角煮")
    //            XCTAssertEqual(result[1].cookingIngredients[0].material, "●豚バラ肉")
    //            XCTAssertEqual(result[1].cookingMethod[0].procedure, "鍋に●の材料すべてと、水をいれます。水の量は、材料がすべてかくれるくらい。豚は、かたまりのままです。")
    //        } catch {
    //            XCTFail(error.localizedDescription)
    //        }
    //    }
}
