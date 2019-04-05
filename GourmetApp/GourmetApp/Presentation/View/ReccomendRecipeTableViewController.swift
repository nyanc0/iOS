//
//  ReccomendRecipeListViewControllerTableViewController.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/04/01.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class ReccomendRecipeTableViewController: UIViewController {
    
    let disposeBag: DisposeBag = DisposeBag()
    var viewModel: ReccomendListViewModel!
    
    @IBOutlet weak var reccomendTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        initViewModel()
        bindViewModel()
    }
    
    
    private func setUpTableView() {
        reccomendTableView.rowHeight = 200.0
        reccomendTableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(RecipeTableViewCell.self))
    }
    
    private func initViewModel() {
        viewModel = ReccomendListViewModel(recipeListUseCase: RecipeListUseCase(recipeListRepository: RecipeListRepositoryImpl()))
    }
    
    private func bindViewModel() {
        let input = ReccomendListViewModel.Input(
            trigger: Driver.just(()),
            tapCell: reccomendTableView.rx.itemSelected.asSignal().map { $0.row})
        
        let output = viewModel.transform(input: input)
        
        output.recipeList.drive(reccomendTableView.rx.items(cellIdentifier: NSStringFromClass(RecipeTableViewCell.self), cellType: RecipeTableViewCell.self)) { (row, element, cell) in
            cell.setData(recipe: element)
        }.disposed(by: disposeBag)
        
        output.load.drive().disposed(by: disposeBag)
        // TODO:インジケーター
    }
}
