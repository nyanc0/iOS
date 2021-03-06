//
//  ReccomendRecipeViewController.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/04/21.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ReccomendRecipeListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private let disposeBag = DisposeBag()
    private var viewModel: ReccomendListViewModel!
    private var cellSizeCache: CGSize!

    @IBOutlet private weak var recipeCollectionView: UICollectionView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationItem()
        initCollectionView()
        initViewModel()
        bindViewModel()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeDetailController" {
            if let viewController = segue.destination as? RecipeDetailViewController,
                let recipe = sender as? Recipe {
                viewController.initViewModel(with: recipe)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Cellのサイズはキャッシュしておく
        guard
            let cache = cellSizeCache else {
                guard let cell = UINib(nibName: "RecipeItemCell", bundle: nil).instantiate(withOwner: self, options: nil).first as? RecipeItemCell else {
                    return CGSize.zero
                }
                cellSizeCache = CGSize(width: cell.getCellWidth(), height: cell.getCellHeight())
                return cellSizeCache
        }
        return cache
    }

    private func initNavigationItem() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    private func initCollectionView() {
        recipeCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        recipeCollectionView.register(UINib(nibName: "RecipeItemCell", bundle: nil), forCellWithReuseIdentifier: "RecipeItemCell")
        if let flowLayout = recipeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
    }

    private func initViewModel() {
        // ここで具象クラス渡すのは微妙...
        viewModel = ReccomendListViewModel(recipeListUseCase: RecipeListUseCase(recipeListRepository: RecipeListRepositoryImpl()), navigator: DetailNavigator(viewController: self))
    }

    /// ViewModelのInput/Outputとのbind
    private func bindViewModel() {
        let input = ReccomendListViewModel.Input(
            trigger: Driver.just(()),
            tapCell: recipeCollectionView.rx.itemSelected.asDriver().map { $0.row }
        )

        let output = viewModel.transform(input: input)

        output.load
            .drive()
            .disposed(by: disposeBag)

        output.recipeList
            .asObservable()
            .bind(to: recipeCollectionView.rx.items(cellIdentifier: "RecipeItemCell", cellType: RecipeItemCell.self)) {  _, element, cell in
                cell.setData(recipe: element)
            }
            .disposed(by: disposeBag)

        output.isLoading
            .asObservable()
            .bind { loading in
                self.recipeCollectionView.isHidden = loading
                self.loadingIndicator.isHidden = !loading
            }
            .disposed(by: disposeBag)

        output.select.drive().disposed(by: disposeBag)
    }
}
