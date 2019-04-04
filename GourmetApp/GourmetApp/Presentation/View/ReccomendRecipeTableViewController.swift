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
class ReccomendRecipeTableViewController: UIViewController, UITableViewDelegate {
    
    let disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var reccomendTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        bindViewModel()
        
        //        reccomendListView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
    }
    
//    /// Itemの数を返す
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
    
//    /// Cellに値をセットして返す
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // セルを取得する
//        if let cell: RecipeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeTableViewCell {
//            // セルに表示する値を設定する
//            return cell
//        }
//        return UITableViewCell()
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setUpTableView() {
        reccomendTableView.rowHeight = 200.0
        reccomendTableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(RecipeTableViewCell.self))
        // Barタップによるスクロールを防止
        reccomendTableView.scrollsToTop = false
    }
    
    private func bindViewModel() {
        let viewModel = ReccomendListViewModel(recipeListUseCase: RecipeListUseCase(recipeListRepository: RecipeListRepositoryImpl()))
        
        reccomendTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // 一覧をTableViewにセット
        viewModel.recipeList.asObservable().bind(to: reccomendTableView.rx.items){ (tableView, row, model) in
            let cell: RecipeTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(RecipeTableViewCell.self)) as! RecipeTableViewCell
            cell.setData(recipe: model)
            return cell
        }.disposed(by: disposeBag)
        
        viewModel.loadRecipe()
    }
}
