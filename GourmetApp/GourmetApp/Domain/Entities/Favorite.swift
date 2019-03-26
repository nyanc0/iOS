//
//  Favorite.swift
//  GourmetApp
//
//  Created by 福岡　侑里奈 on 2019/03/26.
//  Copyright © 2019 yurina fukuoka. All rights reserved.
//

import Foundation
import RealmSwift

class Favorite: Object {
    @objc dynamic var recipeId: String = ""
    @objc dynamic var createdDate : Date = NSDate() as Date
    @objc dynamic var updatedDate : Date = NSDate() as Date
    
    override static func primaryKey() -> String? {
        return "recipeId"
    }
}
