//
//  RecipeDetailViewController.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/04/30.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import UIKit
import MaterialComponents.MDCButton
import RxSwift
import RxCocoa
import RxDataSources

class RecipeDetailViewController: UIViewController {
    
    @IBOutlet private weak var favoriteButton: MDCFloatingButton!
    @IBOutlet private weak var detailTableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var viewModel: DetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initViewModel()
        bindViewModel()
    }
    
    private func initTableView() {
        detailTableView.sectionHeaderHeight = 200
    }
    
    func initViewModel(with recipe: Recipe? = nil) {
        guard let checked = recipe else {
            return
        }
        
        viewModel = DetailViewModel(selectedRecipe: checked)
    }
    
    private func bindViewModel() {
        let input = DetailViewModel.Input(
            trigger: Driver.just(()),
            loadTrigger: Driver.just(()),
            tapFavorite: favoriteButton.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input: input)
        
        output.load
            .drive()
            .disposed(by: disposeBag)
        
        output.favoriteLoad
            .drive()
            .disposed(by: disposeBag)
        
        output.isAdded
            .asObservable()
            .bind { isSaved in
                if isSaved {
                    self.favoriteButton.setImage(UIImage(named: "ic_star_orange"), for: .normal)
                } else {
                    self.favoriteButton.setImage(UIImage(named: "ic_star_border_orange"), for: .normal)
                }
            }.disposed(by: disposeBag)
        
        output.tap
            .drive()
            .disposed(by: disposeBag)
    }
}
