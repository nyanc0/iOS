//
//  RecipeItemCell.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/04/21.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import UIKit
import SDWebImage

class RecipeItemCell: UICollectionViewCell {

    @IBOutlet private weak var contentViewCell: UIView!
    @IBOutlet private weak var recipeItemImage: UIImageView!
    @IBOutlet private weak var reccomendLabel: UILabel!
    @IBOutlet private weak var introductionLabel: UILabel!
    @IBOutlet private weak var widthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthConstraint.constant = screenWidth
        //        setBackground()
    }

    /// 表示内容のセット
    /// - parameters: Recipe
    func setData(recipe: Recipe) {

        recipeItemImage.sd_setImage(with: URL(string: recipe.mainUrl), placeholderImage: UIImage(named: "ic_no_image.png"))

        introductionLabel.text = recipe.introduction

        reccomendLabel.isHidden = !recipe.isReccomend()
        self.layoutIfNeeded()
    }

    /// 背景設定
    //    private func setBackground() {
    //        innerStackView.layer.borderWidth = 0.5
    //        innerStackView.layer.borderColor = UIColor.lightGray.cgColor
    //        innerStackView.layer.shadowColor = UIColor.gray.cgColor
    //        innerStackView.layer.shadowRadius = 2.0
    //        innerStackView.layer.shadowOpacity = 1.0
    //        innerStackView.layer.shadowOffset = CGSize(width: 0, height: 2)
    //        innerStackView.layer.shadowPath = UIBezierPath(rect: innerStackView.bounds).cgPath
    //    }

}
