//
//  FavoriteRecipeListViewController.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/04/29.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class FavoriteRecipeListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private let disposeBag = DisposeBag()
    private var viewModel: FavoriteListViewModel!
    private var cellSizeCache: CGSize!

    @IBOutlet private weak var favoriteCollectionView: UICollectionView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var emptyView: UIView!
    @IBOutlet private weak var errorView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
        initViewModel()
        bindViewModel()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeDetailController" {
            if let vc = segue.destination as? RecipeDetailViewController,
                let recipe = sender as? Recipe {
                vc.initViewModel(with: recipe)
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
                return cellSizeCache!
        }
        return cache
    }

    /// CollectionViewの初期化
    private func initCollectionView() {
        favoriteCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        favoriteCollectionView.register(UINib(nibName: "RecipeItemCell", bundle: nil), forCellWithReuseIdentifier: "RecipeItemCell")
        if let floawLayout = favoriteCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            floawLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
    }

    /// ViewModelの初期化
    /// UseCaseとかImplをここで渡すのは微妙だけどDIコンテナまで入れるのは大変そうなので...
    private func initViewModel() {
        viewModel = FavoriteListViewModel(favoriteUseCase: FavoriteListUseCase(favoriteRepository: FavoriteRepositoryImpl(recipeListRepository: RecipeListRepositoryImpl())), navigator: DetailNavigator(viewController: self))
    }

    /// ViewModelのInput/Outputとのbind
    private func bindViewModel() {
        let input = FavoriteListViewModel.Input(
            trigger: rx.viewWillAppearInvoked.asDriver(onErrorJustReturn: ()),
            tapCell: favoriteCollectionView.rx.itemSelected.asDriver().map { $0.row }
        )

        let output = viewModel.transform(input: input)

        output.recipeList
            .asObservable()
            .filter { recipe in
                self.favoriteCollectionView.isHidden = recipe.isEmpty
                self.emptyView.isHidden = !recipe.isEmpty
                return !recipe.isEmpty
            }
            .bind(to: favoriteCollectionView.rx.items(cellIdentifier: "RecipeItemCell", cellType: RecipeItemCell.self)) {  _, element, cell in
                cell.setData(recipe: element)
            }
            .disposed(by: disposeBag)

        output.error
            .asObservable()
            .bind { _ in
                self.favoriteCollectionView.isHidden = true
                self.errorView.isHidden = false
            }
            .disposed(by: disposeBag)

        output.load
            .drive()
            .disposed(by: disposeBag)

        output.isLoading
            .asObservable()
            .bind { isLoading in
                self.loadingIndicator.isHidden = !isLoading
            }
            .disposed(by: disposeBag)

        output.select.drive().disposed(by: disposeBag)
    }
}
