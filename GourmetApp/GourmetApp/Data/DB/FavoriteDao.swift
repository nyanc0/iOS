//
//  FavoriteDao.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/03/27.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
class FavoriteDao: BaseDao<FavoriteRealmModel> {

    public static var favoriteDao: FavoriteDao = {
        return FavoriteDao()
    }()

    func addOrUpdate(recipeId: String) -> Bool {
        let favoriteModel: FavoriteRealmModel = FavoriteRealmModel()
        let updateFunc = { (favoriteModel: FavoriteRealmModel) -> FavoriteRealmModel in
            favoriteModel.recipeId = recipeId
            return favoriteModel
        }
        return self.addOrUpdate(data: favoriteModel, updateFunc: updateFunc)
    }

}
