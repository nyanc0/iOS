//
//  FavoriteListViewModel.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/04/30.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FavoriteListViewModel: BaseViewModel {

    struct Input {
        /// 表示時のローディングトリガー
        let trigger: Driver<Void>
        /// タップイベント
        let tapCell: Signal<Int>
    }

    struct Output {
        /// ローディングのトリガー.こちらで結果は見ない
        let load: Driver<Void>
        /// ローディングの結果
        let recipeList: Driver<[Recipe]>
        let isLoading: Driver<Bool>
        let error: Driver<Error>
    }

    struct State {
        let content: ArrayTracker<Recipe> = ArrayTracker<Recipe>()
        let isLoading = ActivityIndicator()
        let error = ErrorTracker()
    }

    private let favoriteUseCase: FavoriteListUseCase

    init(favoriteUseCase: FavoriteListUseCase) {
        self.favoriteUseCase = favoriteUseCase
    }

    func transform(input: FavoriteListViewModel.Input) -> FavoriteListViewModel.Output {

        let state = State()

        // 初回ロード
        let load = input.trigger.flatMap { _ in
            self.favoriteUseCase
                .loadFavoriteList()
                .trackArray(state.content)
                .trackError(state.error)
                .trackActivity(state.isLoading)
                .asDriverOnErrorJustComplete()
                .mapToVoid()
        }

        return Output(load: load,
                      recipeList: state.content.asDriver(),
                      isLoading: state.isLoading.asDriver(),
                      error: state.error.asDriver()
        )
    }
}
