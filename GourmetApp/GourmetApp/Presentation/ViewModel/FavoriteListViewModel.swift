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
        let tapCell: Driver<Int>
    }

    struct Output {
        /// ローディングのトリガー.こちらで結果は見ない
        let load: Driver<Void>
        /// ローディングの結果
        let recipeList: Driver<[Recipe]>
        let isLoading: Driver<Bool>
        let error: Driver<Error>
        let select: Driver<Void>
    }

    struct State {
        let content: ArrayTracker<Recipe> = ArrayTracker<Recipe>()
        let isLoading = ActivityIndicator()
        let error = ErrorTracker()
    }

    private let favoriteUseCase: FavoriteListUseCase
    private let navigator: DetailNavigator
    private let state: State

    init(favoriteUseCase: FavoriteListUseCase, navigator: DetailNavigator) {
        self.favoriteUseCase = favoriteUseCase
        self.navigator = navigator
        self.state = State()
    }

    func transform(input: FavoriteListViewModel.Input) -> FavoriteListViewModel.Output {
        // 初回ロード
        let load = input.trigger.flatMap { _ in
            self.favoriteUseCase
                .loadFavoriteList()
                .trackArray(self.state.content)
                .trackError(self.state.error)
                .trackActivity(self.state.isLoading)
                .asDriverOnErrorJustComplete()
                .mapToVoid()
        }

        // タップ
        let tapCell = input.tapCell.withLatestFrom(self.state.content) { [unowned self] (index: Int, recipes: [Recipe]) in
            self.navigator.toDetail(recipe: recipes[index])
        }

        return Output(load: load,
                      recipeList: self.state.content.asDriver(),
                      isLoading: self.state.isLoading.asDriver(),
                      error: self.state.error.asDriver(),
                      select: tapCell
        )
    }
}
