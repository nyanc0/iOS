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
        // タップイベント
        let tapCell: Signal<Recipe>
    }
    
    struct Output {
        // 一覧に表示するレシピ
        let recipeList: Driver<[Recipe]>
        // 選択されたレシピ
        let recipeSelected: Signal<Recipe>
    }
    
    struct State {
        
    }
    
    private let recipeListUseCase: RecipeListUseCase
    private let disposeBag: DisposeBag = DisposeBag()
    private var recipeSelectedRelay: PublishRelay<Recipe>
    private var recipeSelected: Signal<Recipe>
    
    init(with recipeListUseCase: RecipeListUseCase) {
        self.recipeListUseCase = recipeListUseCase
    }
    
    func transform(input: ReccomendListViewModel.Input) -> ReccomendListViewModel.Output {
        
        // タップイベントの通知
        let recipeSelectedRelay = PublishRelay<Recipe>()
        let recipeSelected = recipeSelectedRelay.asSignal()
        self.recipeSelectedRelay = recipeSelectedRelay
        self.recipeSelected = recipeSelected
        
        // 取得したレシピ一覧
        let recipeListRelay = BehaviorRelay<[Recipe]>(value: [])
        let recipeList = recipeListRelay.asDriver(onErrorJustReturn: [])
        
        // サーバーからの取得
        recipeListUseCase.loadReccomendRecipe()
        .observeOn(MainScheduler.instance)
        .subscribe { result in
            switch result {
            case let .success(recipes):
                recipeListRelay.accept(recipes)
                break
            case .error(error: _): break
                break
            }
        }
        .disposed(by: disposeBag)
        
        // TODO: セルタップでの遷移
//        input.tapCell
        
        return Output(recipeList: recipeList, recipeSelected: recipeSelected)
    }
}
