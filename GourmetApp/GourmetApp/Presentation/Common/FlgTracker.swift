//
//  FlgTracker.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/05/03.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//public class FlgTracker<Bool>: SharedSequenceConvertibleType {
//
//    public typealias E = Bool
//    public typealias SharingStrategy = DriverSharingStrategy
//    private let _flg = BehaviorRelay<Bool>(value: false)
//
//    var flg: Bool {
//        return _flg.value
//    }
//
//    func trackFlgOfObservable<O: ObservableConvertibleType>(from source: O) -> Observable<O.E> where O.E == Bool {
//        return source.asObservable().do(onNext: onNext)
//    }
//
//    public func asSharedSequence() -> SharedSequence<DriverSharingStrategy, Bool> {
//        return _flg.asObservable().asDriver(onErrorJustReturn: false)
//    }
//
//    public func  asObservable() -> Observable<Bool> {
//        return _flg.asObservable()
//    }
//
//    private func onNext(_ flg: Bool) {
//        _flg.accept(flg)
//    }
//}
//
//extension ObservableConvertibleType {
//    public func trackFlg(_ flgTracker: FlgTracker<Any>) -> Observable<Bool> {
//        return flgTracker.trackFlgOfObservable(from: self)
//    }
//}
