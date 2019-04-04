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
    // github.com/fumiyasac/RxSwiftUIExample/blob/master/RxSwiftUIExample/ViewController/Search/SearchViewController.swift
    private let recipeListUseCase: RecipeListUseCase
    private let disposeBag: DisposeBag = DisposeBag()
    
    private let recipeSelectedRelay: PublishRelay<Recipe>
    let recipeSelected: Signal<Recipe>
    
    private let recipeListRelay: BehaviorRelay<[Recipe]>
    let recipeList: Driver<[Recipe]>
    
    private let isLoadingRelay: BehaviorRelay<Bool>
    let isLoading:Driver<Bool>
    
    init(recipeListUseCase: RecipeListUseCase) {
        self.recipeListUseCase = recipeListUseCase
        
        // タップイベント
        self.recipeSelectedRelay = PublishRelay<Recipe>()
        self.recipeSelected = recipeSelectedRelay.asSignal()
        
        // レシピ一覧
        self.recipeListRelay = BehaviorRelay<[Recipe]>(value: [])
        self.recipeList = recipeListRelay.asDriver(onErrorJustReturn: [])
        
        // ローディング状態
        self.isLoadingRelay = BehaviorRelay<Bool>(value: true)
        self.isLoading = isLoadingRelay.asDriver()
    }
    
    func loadRecipe(){
        // サーバーからの取得
        recipeListUseCase.loadReccomendRecipe()
            .observeOn(MainScheduler.instance)
            .subscribe { result in
                switch result {
                case let .success(recipes):
                    self.isLoadingRelay.accept(false)
                    self.recipeListRelay.accept(recipes)
                    break
                case .error(error: _):
                    self.isLoadingRelay.accept(false)
                    self.recipeListRelay.accept([])
                    break
                }
            }
            .disposed(by: disposeBag)
        
        // TODO: セルタップでの遷移
        //        input.tapCell
    }
}
