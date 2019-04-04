//
//  ActivityIndicator.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/04/04.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// 実行中のものを管理
class ActivityIndicator: SharedSequenceConvertibleType {
    
    public typealias E = Bool
    public typealias SharingStrategy = DriverSharingStrategy
    
    private let _lock = NSRecursiveLock()
    private let _variable = BehaviorRelay(value: 0)
    private let _loading: SharedSequence<SharingStrategy, Bool>
    
    init() {
        // 前回の状態と比較して変わっていればtrueを返してLoading状態と判断する
        _loading = _variable.asDriver()
            .map{ $0 > 0}
            .distinctUntilChanged()
    }
    
    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.E> {
        return Observable.using( { () -> ActivityToken<O.E> in
            self.increment()
            return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
        }) { t in
            return t.asObservable()
        }
    }
    
    func asSharedSequence() -> SharedSequence<DriverSharingStrategy, Bool> {
        return _loading
    }
    
    private func increment() {
        _lock.lock()
        _ = _variable.value.advanced(by: 1)
        _lock.unlock()
    }
    
    private func decrement() {
        _lock.lock()
        let copy = _variable.value
        _variable.accept(copy - 1)
        _lock.unlock()
    }
    
    
}

private struct ActivityToken<E>: ObservableConvertibleType, Disposable {
    
    private let _source: Observable<E>
    private let _dispose: Cancelable
    
    init(source: Observable<E>, disposeAction: @escaping () -> ()) {
        _source = source
        _dispose = Disposables.create(with: disposeAction)
    }
    
    func asObservable() -> Observable<E> {
        return _source
    }
    
    func dispose() {
        _dispose.dispose()
    }
}
