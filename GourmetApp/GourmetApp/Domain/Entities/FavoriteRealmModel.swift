//
//  FavoriteRealmModel.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/03/26.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import RealmSwift
class FavoriteRealmModel: BaseRealmModel {
    @objc dynamic var recipeId: String = ""
    override static func primaryKey() -> String? {
        return "recipeId"
    }
}
