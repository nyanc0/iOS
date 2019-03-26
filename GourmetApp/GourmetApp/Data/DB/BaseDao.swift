//
//  BaseDao.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/03/26.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import RealmSwift
class BaseDao<T: BaseRealmModel> {
    static var realm: Realm {
        do {
            return try Realm()
        } catch {
            print("\(error.localizedDescription) ")
        }
        return self.realm
    }
    
    /// 全件取得
    func findAll() -> Results<T> {
        return BaseDao<T>.realm.objects(T.self)
    }
    
    /// レコード取得
    /// - parameter key: プライマリキー
    /// - returns: 検索結果
    func findById(key: AnyObject) -> T? {
        return BaseDao<T>.realm.object(ofType: T.self, forPrimaryKey: key)
    }
    
    /// レコード追加
    /// - parameter data: 保存レコード
    func addOrUpdate(data: T, updateFunc:(_ data: T) -> (T)) -> Bool {
        do {
            try BaseDao<T>.realm.write {
                var updatingData = updateFunc(data)
                updatingData = setDefaultColumnValue(data: data)
                BaseDao<T>.realm.add(updatingData, update: true)
            }
            return true
        } catch let error as NSError {
            print("\(error.localizedDescription) ")
        }
        return false
    }
    
    /// レコード削除
    /// - parameter data: 削除レコード
    func delete(data: T) {
        do {
            try BaseDao<T>.realm.write {
                BaseDao<T>.realm.delete(data)
            }
        } catch let error as NSError {
            print("\(error.localizedDescription) ")
        }
    }
    
    /// レコード全削除
    func deleteAll() {
        let objs = BaseDao<T>.realm.objects(T.self)
        do {
            try BaseDao<T>.realm.write {
                BaseDao<T>.realm.delete(objs)
            }
        } catch let error as NSError {
            print("\(error.localizedDescription) ")
        }
    }
    
    private func setDefaultColumnValue(data: T) -> (T) {
        if BaseDao<T>.realm.isInWriteTransaction {
            data.createdDate = Date()
        } else {
            do {
                try BaseDao<T>.realm.write {
                    data.updatedDate = Date()
                }
            } catch let error as NSError {
                print("\(error.localizedDescription) ")
            }
        }
        return data
    }
}
