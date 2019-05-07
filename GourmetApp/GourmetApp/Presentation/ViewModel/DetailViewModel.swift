//
//  DetailViewModel.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/05/02.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DetailViewModel: BaseViewModel {

    // https://www.okadalabo.com/scroll-view-内に-tabel-viewを配置して、table-viewの高さは成り行きで、/

    struct Input {
        /// 表示時のローディングトリガー
        let trigger: Driver<Void>
        /// お気に入り読み込みのトリガー
        let loadTrigger: Driver<Void>
        /// お気に入り
        let tapFavorite: Driver<Void>
    }

    struct Output {
        let load: Driver<Void>
        let favoriteLoad: Driver<Void>
        let recipe: Driver<[Recipe]>
        let error: Driver<Error>
        let isAdded: Driver<Bool>
        let tap: Driver<Void>
        let ingradients: Driver<[CookingIngredients]>
        let methods: Driver<[CookingMethod]>
    }

    struct State {
        let content: ArrayTracker<Recipe> = ArrayTracker<Recipe>()
        let error = ErrorTracker()
        let isSaved = BehaviorRelay(value: false)
        let ingradients: BehaviorRelay<[CookingIngredients]> = BehaviorRelay(value: [])
        let methods: BehaviorRelay<[CookingMethod]> = BehaviorRelay(value: [])
    }

    private let detailUseCase = DetailUseCase(favoriteRepository: FavoriteRepositoryImpl(recipeListRepository: RecipeListRepositoryImpl()), recipeDetailRepository: RecipeDetailRepositoryImpl())
    private let selectedRecipe: Recipe

    init(selectedRecipe: Recipe) {
        self.selectedRecipe = selectedRecipe
    }

    func transform(input: DetailViewModel.Input) -> DetailViewModel.Output {

        let state = State()

        let load = input.trigger.flatMap { [unowned self] _ in
            self.detailUseCase
                .loadDetail(recipeId: self.selectedRecipe.recipeId)
                .trackArray(state.content)
                .map { results in
                    self.mapTo(recipe: results[0], state: state)
                }
                .asDriverOnErrorJustComplete()
                .mapToVoid()
        }

        let favoriteLoad = input.loadTrigger.flatMap { [unowned self] _ in
            self.detailUseCase
                .checkRecipeSaved(recipeId: self.selectedRecipe.recipeId)
                .filter { isSaved in
                    state.isSaved.accept(isSaved)
                    return isSaved
                }
                .asDriver(onErrorJustReturn: false)
                .mapToVoid()
        }

        let tap = input.tapFavorite.map { _ in
            if state.isSaved.value {
                state.isSaved.accept(false)
                _ = self.detailUseCase.deleteRecipe(recipe: self.selectedRecipe)
            } else {
                state.isSaved.accept(true)
                _ = self.detailUseCase.saveRecipe(recipe: self.selectedRecipe)
            }
        }

        return Output(load: load,
                      favoriteLoad: favoriteLoad,
                      recipe: state.content.asDriver(),
                      error: state.error.asDriver(),
                      isAdded: state.isSaved.asDriver(),
                      tap: tap,
                      ingradients: state.ingradients.asDriver(),
                      methods: state.methods.asDriver())
    }

    func mapTo(recipe: Recipe, state: State) {
        state.ingradients.accept(recipe.cookingIngredients)
        state.methods.accept(recipe.cookingMethod)
    }
}
