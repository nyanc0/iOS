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
    
    func initViewModel(with recipe: Recipe? = nil) {
        guard let checked = recipe else {
            return
        }
        viewModel = DetailViewModel(selectedRecipe: checked)
    }

    private func initTableView() {
//        detailTableView.rx.setDelegate(self).disposed(by: disposeBag)
//        detailTableView.sectionHeaderHeight = 230
//        detailTableView.register(MainImageView.self, forHeaderFooterViewReuseIdentifier: "MainImageView")
    }
    
    private func initImageView() {
        
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
                self.mainImageView.sd_setImage(with: URL(string: result?.mainUrl ?? ""), placeholderImage: UIImage(named: "ic_no_image.png"), options: SDWebImageOptions(rawValue: 0), completed: {(image, error, cacheType, imageURL) in
                    guard let image = image else { return }
                    self.mainImageView.image = image.resize(size: CGSize(width: UIScreen.main.bounds.size.width, height: self.getImgeHeight()))
                })
            }.disposed(by: disposeBag)

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
    
    func getImgeHeight() -> CGFloat {
        return ((UIScreen.main.bounds.width * 4) / CGFloat(5))
    }
}

extension UIImage {
    func resize(size _size: CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
        
        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0) // 変更
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
