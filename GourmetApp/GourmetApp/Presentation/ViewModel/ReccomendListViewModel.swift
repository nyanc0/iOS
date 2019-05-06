//
//  ReccomentListViewModel.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/04/02.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ReccomendListViewModel: BaseViewModel {

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

    private let recipeListUseCase: RecipeListUseCase
    private let navigator: DetailNavigator

    init(recipeListUseCase: RecipeListUseCase, navigator: DetailNavigator) {
        self.recipeListUseCase = recipeListUseCase
        self.navigator = navigator
    }

    func transform(input: ReccomendListViewModel.Input) -> Output {
        let state = State()

        // 初回ロード
        let load = input.trigger.flatMap { [unowned self] _ in
            self.recipeListUseCase
                .loadReccomendRecipe()
                .trackArray(state.content)
                .trackError(state.error)
                .trackActivity(state.isLoading)
                .asDriverOnErrorJustComplete()
                .mapToVoid()
        }

        // タップ
        let tapCell = input
            .tapCell
            .withLatestFrom(state.content) { [unowned self] (index: Int, recipes: [Recipe]) in
                self.navigator.toDetail(recipe: recipes[index])
        }

        return Output(
            load: load,
            recipeList: state.content.asDriver(),
            isLoading: state.isLoading.asDriver(),
            error: state.error.asDriver(),
            select: tapCell
        )
    }
}
