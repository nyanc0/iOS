//
//  BaseRealmModel.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/03/26.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import RealmSwift
class BaseRealmModel: Object {
    @objc dynamic var createdDate: Date = NSDate() as Date
    @objc dynamic var updatedDate: Date = NSDate() as Date
}
