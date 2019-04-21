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

class ReccomendRecipeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private let disposeBag = DisposeBag()
    private var viewModel: ReccomendListViewModel!

    @IBOutlet private weak var recipeCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initCollectionView()
        initViewModel()
        bindViewModel()
    }

    // UICollectionViewの外周余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    // Cellのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 300)
    }
    // 行の最小余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    // 列の最小余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    private func initCollectionView() {
        recipeCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        recipeCollectionView.register(UINib(nibName: "RecipeItemCell", bundle: nil), forCellWithReuseIdentifier: "RecipeItemCell")
    }

    private func initViewModel() {
        viewModel = ReccomendListViewModel(recipeListUseCase: RecipeListUseCase(recipeListRepository: RecipeListRepositoryImpl()))
    }

    private func bindViewModel() {
        let input = ReccomendListViewModel.Input(
            trigger: Driver.just(()),
            tapCell: recipeCollectionView.rx.itemSelected.asSignal().map { $0.row }
        )

        let output = viewModel.transform(input: input)

        output.recipeList
            .asObservable()
            .bind(to: recipeCollectionView.rx.items(cellIdentifier: "RecipeItemCell", cellType: RecipeItemCell.self)) {  _, element, cell in
                cell.setData(recipe: element)
            }
            .disposed(by: disposeBag)

        output.load
            .drive()
            .disposed(by: disposeBag)

        output.isLoading
            .asObservable()
            .bind { loading in
                UIApplication.shared.isNetworkActivityIndicatorVisible = loading
            }
            .disposed(by: disposeBag)
    }
}
