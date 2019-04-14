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
import RxDataSources
class ReccomendRecipeTableViewController: UIViewController, UITableViewDelegate {

    let disposeBag: DisposeBag = DisposeBag()
    var viewModel: ReccomendListViewModel!

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        initViewModel()
        bindViewModel()
    }

    private func setUpTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.rowHeight = 300
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "RecipeCell")
        tableView.separatorStyle = .none
    }

    private func initViewModel() {
        viewModel = ReccomendListViewModel(recipeListUseCase: RecipeListUseCase(recipeListRepository: RecipeListRepositoryImpl()))
    }

    private func bindViewModel() {
        let input = ReccomendListViewModel.Input(
            trigger: Driver.just(()),
            tapCell: tableView.rx.itemSelected.asSignal().map { $0.row})

        let output = viewModel.transform(input: input)

        output.recipeList.asObservable().bind(to: tableView.rx.items(cellIdentifier: "RecipeCell", cellType: RecipeCell.self)) {  (_, element, cell) in
            cell.setData(recipe: element)
            }.disposed(by: disposeBag)


        output.load.drive().disposed(by: disposeBag)
        // TODO:インジケーター
    }
}
