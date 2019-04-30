//
//  RecipeItemCell.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/04/21.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import UIKit
import SDWebImage
import MaterialComponents.MaterialCards

class RecipeItemCell: MDCCardCollectionCell {

    @IBOutlet private weak var contentViewCell: UIView!
    @IBOutlet private weak var recipeItemImage: UIImageView!
    @IBOutlet private weak var reccomendLabel: UILabel!
    @IBOutlet private weak var introductionLabel: UILabel!
    @IBOutlet private weak var labelContainer: UIStackView!
    @IBOutlet private weak var widthConstraint: NSLayoutConstraint!

    private let margin: CGFloat = 8

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        widthConstraint.constant = getCellWidth()
        setShadowElevation(ShadowElevation(margin), for: .selected)
        setShadowColor(UIColor.black, for: .highlighted)
    }

    /// 表示内容のセット
    /// - parameters: Recipe
    func setData(recipe: Recipe) {
        recipeItemImage.sd_setImage(with: URL(string: recipe.mainUrl), placeholderImage: UIImage(named: "ic_no_image.png"))
        introductionLabel.text = recipe.introduction
        reccomendLabel.isHidden = !recipe.isReccomend()
        self.layoutIfNeeded()
    }

    /// Cellの横幅を返す.
    /// - returns: 画面サイズから左右のマージンを引いたCellの横幅
    func getCellWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width - (margin * 2)
    }

    /// Cellの縦幅を返す.
    /// - returns: Storyboardの画像比率に合わせてCellの縦幅を返す.
    func getCellHeight() -> CGFloat {
        return ((UIScreen.main.bounds.width * 3) / CGFloat(5)) + getLabelContainerHeight()
    }

    /// LabelContainerの縦幅を返す.
    /// - returns: reccomendLabelとintroductionLabelが入ったコンテナViewの高さ
    private func getLabelContainerHeight() -> CGFloat {
        return labelContainer.frame.height
    }
}
