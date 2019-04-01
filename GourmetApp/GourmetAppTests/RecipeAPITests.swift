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
    let json = "[{\"cooking_ingredients\": [{\"material\": \"合いびき肉\",\"quantity\": \"200ｇ\"},{\"material\": \"玉ねぎ\",\"quantity\": \"1個\"},{\"material\": \"卵\",\"quantity\": \"1個\"},{\"material\": \"パン粉\",\"quantity\": \"大2\"},{\"material\": \"牛乳\",\"quantity\": \"大1\"},{\"material\": \"塩コショウ\",\"quantity\": \"少々\"},{\"material\": \"●酒\",\"quantity\": \"大2\"},{\"material\": \"玉ねぎ\",\"quantity\": \"1個\"},{\"material\": \"●ケチャップ\",\"quantity\": \"大2\"},{\"material\": \"●中濃ソース\",\"quantity\": \"大1\"},{\"material\": \"●砂糖\",\"quantity\": \"大1\"},{\"material\": \"●醤油\",\"quantity\": \"大1\"}],\"cooking_method\": [{\"procedure_no\": \"1\",\"procedure\": \"玉ねぎはみじん切りにし、●以外の材料すべてをボウルに入れて手でよくこねる。\"},{\"procedure_no\": \"2\",\"procedure\": \"成形し、フライパンに油（分量外）をひき、中火で焼き目がつくように焼き、ふたをして中に火が通るように蒸す。\"},{\"procedure_no\": \"3\",\"procedure\": \"ハンバーグを皿に取り、そのフライパンに●をすべて入れて、弱火で煮立つまで温め、ハンバーグにかけたら完成です。\"}],\"genre_cd\": \"G01\",\"genre_name\": \"お肉のおかず\",\"recipe_id\": \"001\",\"recipe_name\": \"洋食屋さんのハンバーグ\",\"introduction\": \"味も見た目もよし！のハンバーグです。\",\"main_gazo\": \"http://localhost:3000/assets/images/recipe_001.png\",\"recommended_flg\": \"1\"},{\"cooking_ingredients\": [{\"material\": \"●豚バラ肉\",\"quantity\": \"500ｇ\"},{\"material\": \"●しょうが\",\"quantity\": \"1かけ\"},{\"material\": \"●ねぎの青い部分\",\"quantity\": \"1本\"},{\"material\": \"●酒\",\"quantity\": \"50ｃｃ\"},{\"material\": \"○大根\",\"quantity\": \"1/2本\"},{\"material\": \"○醤油\",\"quantity\": \"50ｃｃ\"},{\"material\": \"●酒\",\"quantity\": \"大2\"},{\"material\": \"○砂糖\",\"quantity\": \"大3\"},{\"material\": \"水\",\"quantity\": \"適量\"}],\"cooking_method\": [{\"procedure_no\": \"1\",\"procedure\": \"鍋に●の材料すべてと、水をいれます。水の量は、材料がすべてかくれるくらい。豚は、かたまりのままです。\"},{\"procedure_no\": \"2\",\"procedure\": \"沸騰するまで、強火。その後、ごく弱火で1時間煮ます。この時、キッチンパーパーで落としぶたをします。\"},{\"procedure_no\": \"3\",\"procedure\": \"火をとめ、少しさめるまでそのままに。あら熱がとれたら、豚肉以外の材料を捨て、豚肉を軽く水洗いします。この作業で豚肉の臭みとり。\"},{\"procedure_no\": \"4\",\"procedure\": \"大根は、皮をむいて、3ｃｍの輪切りに。大きいものは、半月切りにします。豚肉は5ｃｍ角くらいに切ります。\"},{\"procedure_no\": \"5\",\"procedure\": \"豚肉,大根、○の材料、材料がかくれるくらいの水を鍋に入れ、1時間ごく弱火で煮ます。この時も、キッチンペーパーで落としぶたをします。\"},{\"procedure_no\": \"6\",\"procedure\": \"その後、中強火で、水分を飛ばし、完成です。\"}],\"genre_cd\": \"G01\",\"genre_name\": \"お肉のおかず\",\"recipe_id\": \"002\",\"recipe_name\": \"基本の豚の角煮\",\"introduction\": \"とろとろの豚の角煮って美味しいですよね。家庭で作れたら最高！沢山煮込むのでとろとろですよ。\",\"main_gazo\": \"http://localhost:3000/assets/images/recipe_002.png\",\"recommended_flg\": \"1\"}]"

    override func setUp() {
        super.setUp()
        recipeListRepository = RecipeListRepositoryImpl()
        recipeDetailRepository = RecipeDetailRepositoryImpl()
    }

    func testGetRecipeList() {
        self.stub(uri("http://localhost:3000/recipe?"), jsonData(json.data(using: .utf8)!))
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
        self.stub(uri("http://localhost:3000/recipe?recipe_id=001&recipe_id=002"), jsonData(json.data(using: .utf8)!))
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

    func testGetRecipeWithId() {
        self.stub(uri("http://localhost:3000/recipe?recipe_id=001"), jsonData(json.data(using: .utf8)!))
        do {
            let result: Recipe? = try recipeDetailRepository.getRecipeDetail("001").toBlocking().single()
            if result == nil {
                XCTFail("Result is Nil")
            }
            XCTAssertEqual(result!.recipeId, "001")
            XCTAssertEqual(result!.recipeName, "洋食屋さんのハンバーグ")
            XCTAssertEqual(result!.cookingIngredients[0].material, "合いびき肉")
            XCTAssertEqual(result!.cookingMethod[0].procedure, "玉ねぎはみじん切りにし、●以外の材料すべてをボウルに入れて手でよくこねる。")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testGetReccomendRecipe() {
        self.stub(uri("http://localhost:3000/recipe?recommended_flg=1"), jsonData(json.data(using: .utf8)!))
        do {
            let result: [Recipe] = try recipeListRepository.getRecipeList(reccomendFlg: "1").toBlocking().single()
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
}
