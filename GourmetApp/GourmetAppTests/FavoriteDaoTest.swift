//
//  FavoriteDaoTest.swift
//  GourmetAppTests
//
//  Created by yurina fukuoka on 2019/03/27.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import Mockingjay
import RxTest
import RxBlocking
@testable import GourmetApp
class FavoriteDaoTest: XCTestCase {
    var favoriteDao: FavoriteDao!
    
    override func setUp() {
        favoriteDao = FavoriteDao.favoriteDao
    }
    
    func testAdd() {
        let result = favoriteDao.addOrUpdate(recipeId: "001")
        XCTAssert(result)
    }
    
    func testFindById() {
        _ = favoriteDao.addOrUpdate(recipeId: "001")
        _ = favoriteDao.addOrUpdate(recipeId: "002")
        do {
            let result = try favoriteDao.findById(key: "001").toBlocking().single()
            XCTAssertEqual(result?.recipeId, "001")
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testFindAll() {
        _ = favoriteDao.addOrUpdate(recipeId: "001")
        _ = favoriteDao.addOrUpdate(recipeId: "002")
        do {
            let results = try favoriteDao.findAll().toBlocking().single()
            XCTAssertEqual(results[0].recipeId, "001")
            XCTAssertEqual(results[1].recipeId, "002")
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testDeleteById() {
        _ = favoriteDao.addOrUpdate(recipeId: "001")
        _ = favoriteDao.addOrUpdate(recipeId: "002")
        XCTAssert(favoriteDao.delete(key: "001"))
    }
    
    func testDeleteAll() {
        _ = favoriteDao.addOrUpdate(recipeId: "001")
        _ = favoriteDao.addOrUpdate(recipeId: "002")
        XCTAssert(favoriteDao.deleteAll())
    }
}
