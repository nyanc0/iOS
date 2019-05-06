//
//  BaseDao.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/03/26.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

class BaseDao<T: Object> {
    static var realm: Realm {
        do {
            return try Realm()
        } catch {
            print("\(error.localizedDescription) ")
        }
        return self.realm
    }

    /// 全件取得
    func findAll() -> Single<Results<T>> {
        return Single<Results<T>>.create { observer in
            let results: Results<T> = BaseDao<T>.realm.objects(T.self).sorted(byKeyPath: "updatedDate", ascending: true)
            observer(.success(results))
            return Disposables.create()
        }
    }

    /// レコード取得
    /// - parameter key: プライマリキー
    /// - returns: 検索結果
    func findById(key: String) -> Single<T?> {
        return Single<T?>.create { observer in
            if let result = BaseDao<T>.realm.object(ofType: T.self, forPrimaryKey: key) {
                observer(.success(result))
            } else {
                observer(.success(nil))
            }
            return Disposables.create()
        }
    }

    func isSaved(key: String) -> Bool {
        if BaseDao<T>.realm.object(ofType: T.self, forPrimaryKey: key) != nil {
            return true
        } else {
            return false
        }
    }

    /// レコード追加
    /// - parameter data: 保存レコード
    func addOrUpdate(data: T) -> Bool {
        do {
            try BaseDao<T>.realm.write {
                BaseDao<T>.realm.add(data, update: true)
            }
            return true
        } catch let error as NSError {
            print("\(error.localizedDescription) ")
        }
        return false
    }

    /// レコード削除
    /// - parameter data: 削除レコード
    func delete(data: T) -> Bool {
        do {
            try BaseDao<T>.realm.write {
                BaseDao<T>.realm.delete(data)
            }
            return true
        } catch let error as NSError {
            print("\(error.localizedDescription) ")
        }
        return false
    }

    /// レコード削除
    /// - parameter key: Primary Key
    func delete(key: String) -> Bool {
        do {
            try BaseDao<T>.realm.write {
                let data: T? = BaseDao<T>.realm.object(ofType: T.self, forPrimaryKey: key)
                if data != nil {
                    BaseDao<T>.realm.delete(data!)
                }
            }
            return true
        } catch let error as NSError {
            print("\(error.localizedDescription) ")
        }
        return false
    }

    /// レコード全削除
    func deleteAll() -> Bool {
        let objs = BaseDao<T>.realm.objects(T.self)
        do {
            try BaseDao<T>.realm.write {
                BaseDao<T>.realm.delete(objs)
            }
            return true
        } catch let error as NSError {
            print("\(error.localizedDescription) ")
        }
        return false
    }

    //    private func setDefaultColumnValue(data: T) -> (T) {
    //        if BaseDao<T>.realm.isInWriteTransaction {
    //            data.createdDate = Date()
    //        } else {
    //            do {
    //                try BaseDao<T>.realm.write {
    //                    data.updatedDate = Date()
    //                }
    //            } catch let error as NSError {
    //                print("\(error.localizedDescription) ")
    //            }
    //        }
    //        return data
    //    }

    /**
     * 新規主キー発行
     */
    func newId() -> Int? {
        guard let key = T.primaryKey() else {
            //primaryKey未設定
            return nil
        }

        if let last = BaseDao<T>.realm.objects(T.self).last,
            let lastId = last[key] as? Int {
            return lastId + 1
        } else {
            return 1
        }
    }
}
