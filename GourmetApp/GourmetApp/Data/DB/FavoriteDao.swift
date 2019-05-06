//
//  FavoriteDao.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/03/27.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

class FavoriteDao: BaseDao<FavoriteRealmModel> {

    public static var favoriteDao: FavoriteDao = {
        FavoriteDao()
    }()

    //    func findByRecipeId(recipeId: String) -> Single<FavoriteRealmModel?> {
    //        return self.findById(key: recipeId)
    //    }
    //
    func addOrUpdate(recipeId: String) -> Bool {
        let favoriteModel = FavoriteRealmModel()
        favoriteModel.recipeId = recipeId
        return self.addOrUpdate(data: favoriteModel)
    }
}
