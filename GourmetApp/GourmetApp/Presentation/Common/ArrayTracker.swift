//
//  ArrayTracker.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/04/05.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ArrayTracker<T>: SharedSequenceConvertibleType {

    typealias SharingStrategy = DriverSharingStrategy

    private let _array = BehaviorRelay<[T]>(value: [])

    var array: [T] {
        return _array.value
    }

    func trackArray<O: ObservableConvertibleType>(from source: O) -> Observable<O.E> where O.E == [T] {
        return source.asObservable().do(onNext: onNext)
    }

    func asSharedSequence() -> SharedSequence<SharingStrategy, [T]> {
        return _array.asObservable().asDriver(onErrorJustReturn: [])
    }

    func asObservable() -> Observable<[T]> {
        return _array.asObservable()
    }

    private func onNext(_ array: [T]) {
        _array.accept(array)
    }
}

extension ObservableConvertibleType {
    func trackArray<T>(_ arrayTracker: ArrayTracker<T>) -> Observable<E> where E == [T] {
        return arrayTracker.trackArray(from: self)
    }
}
