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
    @IBOutlet private weak var ingradientTableView: UITableView!
    @IBOutlet private weak var methodTableView: UITableView!
    @IBOutlet private weak var ingredientsTableHeight: NSLayoutConstraint!
    @IBOutlet private weak var methodsTableHeight: NSLayoutConstraint!

    private let disposeBag = DisposeBag()
    private var viewModel: DetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initViewModel()
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ingredientsTableHeight.constant = ingradientTableView.contentSize.height
        methodsTableHeight.constant = methodTableView.contentSize.height
    }

    func initViewModel(with recipe: Recipe? = nil) {
        guard let checked = recipe else {
            return
        }
        viewModel = DetailViewModel(selectedRecipe: checked)
    }

    private func initTableView() {
        ingradientTableView.sectionHeaderHeight = 50
        ingradientTableView.rowHeight = 30
        ingradientTableView.rx.setDelegate(self).disposed(by: disposeBag)
        ingradientTableView.register(UINib(nibName: "IngredientViewCell", bundle: nil), forCellReuseIdentifier: "IngredientViewCell")
        ingradientTableView.tableFooterView = UIView()

        methodTableView.sectionHeaderHeight = 50
        methodTableView.rowHeight = 30
        methodTableView.rx.setDelegate(self).disposed(by: disposeBag)
        methodTableView.register(UINib(nibName: "MethodViewCell", bundle: nil), forCellReuseIdentifier: "MethodViewCell")
        methodTableView.tableFooterView = UIView()
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
                self.setMainImage(url: result?.mainUrl)
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
    }

    /// メイン画像のセット
    /// - parameter : 画像URL
    private func setMainImage(url: String?) {
        mainImageView.sd_setImage(with: URL(string: url ?? ""), placeholderImage: UIImage(named: "ic_no_image.png"),
                                  options: SDWebImageOptions(rawValue: 0), completed: {image, _, _, _ in
                                    guard let image = image else { return }
                                    self.mainImageView.image = image.resize(cgSize: CGSize(width: UIScreen.main.bounds.size.width, height: self.getImgeHeight()))
        })
    }

    /// MainImageViewの高さサイズを返す.
    private func getImgeHeight() -> CGFloat {
        return ((UIScreen.main.bounds.width * 4) / CGFloat(5))
    }

    private func checkTableView(_ tableView: UITableView) {
        if tableView.tag == 0 {

        } else {

        }
    }
}

/// ここに書くのは微妙だけどここでしかつかわないので...
extension UIImage {
    func resize(cgSize: CGSize) -> UIImage? {
        let widthRatio = cgSize.width / size.width
        let heightRatio = cgSize.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio

        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0) // 変更
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}
