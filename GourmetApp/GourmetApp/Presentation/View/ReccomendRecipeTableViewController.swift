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
    //    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Recipe>>(
    //        configureCell: { (_, tableView, _, recipes) in
    //            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as! RecipeTableViewCell
    //            cell.setData(recipe: recipes)
    //            return cell
    //    }
    //    )

    @IBOutlet weak var reccomendTableView: UITableView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        initViewModel()
        bindViewModel()
    }

    private func setUpTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
        //        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    private func initViewModel() {
        viewModel = ReccomendListViewModel(recipeListUseCase: RecipeListUseCase(recipeListRepository: RecipeListRepositoryImpl()))
    }

    private func bindViewModel() {
        let input = ReccomendListViewModel.Input(
            trigger: Driver.just(()),
            tapCell: tableView.rx.itemSelected.asSignal().map { $0.row})

        let output = viewModel.transform(input: input)

        output.recipeList.asObservable().bind(to: tableView.rx.items(cellIdentifier: "RecipeTableViewCell", cellType: RecipeTableViewCell.self)) {  (_, element, cell) in
            //            cell.textLabel?.text = element.introduction
            cell.setData(recipe: element)
            }.disposed(by: disposeBag)


        output.load.drive().disposed(by: disposeBag)
        // TODO:インジケーター
    }
}
