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
        super.setUp()
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
            let result = try favoriteDao.findById(key: "002").toBlocking().single()
            if result != nil {
                XCTAssertEqual(result!.recipeId, "002")
            } else {
                XCTFail("Result is Nil")
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testFindAll() {
        _ = favoriteDao.addOrUpdate(recipeId: "001")
        _ = favoriteDao.addOrUpdate(recipeId: "002")
        do {
            let results = try favoriteDao.findAll().toBlocking().single()
            XCTAssert(results.count == 2)
            XCTAssertEqual(results[0].recipeId, "001")
            XCTAssertEqual(results[1].recipeId, "002")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testDeleteById() {
        _ = favoriteDao.addOrUpdate(recipeId: "001")
        _ = favoriteDao.addOrUpdate(recipeId: "002")
        _ = favoriteDao.delete(key: "001")
        do {
            let resultDeleted = try favoriteDao.findById(key: "001").toBlocking().single()
            let resultSaved = try favoriteDao.findById(key: "002").toBlocking().single()
            if resultDeleted == nil && resultSaved != nil {
                XCTAssertEqual(resultSaved!.recipeId, "002")
            } else {
                XCTFail("Result is Nil")
            }
        } catch {
            XCTFail(error.localizedDescription)
        }

    }

    func testDeleteAll() {
        _ = favoriteDao.addOrUpdate(recipeId: "001")
        _ = favoriteDao.addOrUpdate(recipeId: "002")
        _ = favoriteDao.deleteAll()

        do {
            let results = try favoriteDao.findAll().toBlocking().single()
            XCTAssert(results.isEmpty)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testIsSaved() {
        _ = favoriteDao.deleteAll()
        _ = favoriteDao.addOrUpdate(recipeId: "001")

        XCTAssert(favoriteDao.isSaved(key: "001"))
        XCTAssert(!favoriteDao.isSaved(key: "002"))
    }
}
