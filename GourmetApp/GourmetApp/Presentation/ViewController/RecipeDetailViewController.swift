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
import SDWebImage

class RecipeDetailViewController: UIViewController, UITableViewDelegate {

    @IBOutlet private weak var favoriteButton: MDCFloatingButton!
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var introductionLabel: UILabel!
    @IBOutlet private weak var ingradientTableView: UITableView!
    @IBOutlet private weak var methodTableView: UITableView!
    @IBOutlet private weak var ingredientsTableHeight: NSLayoutConstraint!
    @IBOutlet private weak var methodsTableHeight: NSLayoutConstraint!
    @IBOutlet private weak var contentStackViewWidth: NSLayoutConstraint!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!

    @IBOutlet private weak var recipeContentView: UIScrollView!
    private let disposeBag = DisposeBag()
    private var viewModel: DetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initViewModel()
        bindViewModel()

        contentStackViewWidth.constant = UIScreen.main.bounds.size.width
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ingredientsTableHeight.constant = ingradientTableView.contentSize.height
        methodsTableHeight.constant = methodTableView.contentSize.height + favoriteButton.frame.size.height + 16
    }

    func initViewModel(with recipe: Recipe? = nil) {
        guard let checked = recipe else {
            return
        }
        viewModel = DetailViewModel(selectedRecipe: checked)
    }

    private func initTableView() {
        ingradientTableView.rowHeight = UITableView.automaticDimension
        ingradientTableView.rx.setDelegate(self).disposed(by: disposeBag)
        ingradientTableView.register(UINib(nibName: "IngredientViewCell", bundle: nil), forCellReuseIdentifier: "IngredientViewCell")
        ingradientTableView.tableFooterView = UIView(frame: CGRect.zero)

        methodTableView.rowHeight = UITableView.automaticDimension
        methodTableView.rx.setDelegate(self).disposed(by: disposeBag)
        methodTableView.register(UINib(nibName: "MethodViewCell", bundle: nil), forCellReuseIdentifier: "MethodViewCell")
        methodTableView.tableFooterView = UIView(frame: CGRect.zero)
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

        output.recipe
            .asObservable()
            .bind { result in
                self.navigationItem.title = result?.recipeName
                self.setMainImage(url: result?.mainUrl)
                self.setIntroduction(introduction: result?.introduction)
            }.disposed(by: disposeBag)

        let ingradientDataSource = IngredientDataSource()
        output.ingradients
            .asObservable()
            .bind(to: ingradientTableView.rx.items(dataSource: ingradientDataSource))
            .disposed(by: disposeBag)

        let methodDataSource = MethodDataSource()
        output.methods
            .asObservable()
            .bind(to: methodTableView.rx.items(dataSource: methodDataSource))
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

        output.isLoading
            .asObservable()
            .bind { isLoading in
                self.recipeContentView.isHidden = isLoading
                self.loadingIndicator.isHidden = !isLoading
            }
            .disposed(by: disposeBag)
    }

    /// メイン画像のセット
    /// - parameter : 画像URL
    private func setMainImage(url: String?) {
        mainImageView.sd_setImage(with: URL(string: url ?? ""), placeholderImage: UIImage(named: "ic_no_image.png"))
    }

    /// 紹介文のセット
    private func setIntroduction(introduction: String?) {
        self.introductionLabel.text = introduction ?? ""
    }

    /// MainImageViewの高さサイズを返す.
    private func getImgeHeight() -> CGFloat {
        return ((UIScreen.main.bounds.width * 4) / CGFloat(5))
    }
}
