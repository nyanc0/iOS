//
//  FavoriteRealmModel.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/03/26.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteRealmModel: Object {

    @objc dynamic var recipeId: String = ""
    @objc dynamic var createdDate: Date = NSDate() as Date
    @objc dynamic var updatedDate: Date = NSDate() as Date

    override static func primaryKey() -> String? {
        return "recipeId"
    }
}
