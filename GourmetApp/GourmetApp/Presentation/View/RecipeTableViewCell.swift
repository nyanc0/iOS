//
//  RecipeCellTableViewCell.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/04/01.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import UIKit
import SDWebImage
class RecipeTableViewCell: UITableViewCell {


    @IBOutlet weak var cellMainImage: UIImageView!
    @IBOutlet weak var introductionLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(recipe: Recipe) {
        introductionLabel.text = recipe.introduction
        cellMainImage.sd_setImage(with: URL(string: recipe.mainUrl), placeholderImage: UIImage(named: "ic_no_image.png"))
    }
}
