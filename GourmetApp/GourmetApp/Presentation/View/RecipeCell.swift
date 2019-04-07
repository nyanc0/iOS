//
//  RecipeCell.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/04/07.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import UIKit
import SDWebImage
class RecipeCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var introduction: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(recipe: Recipe) {
        recipeImage.sd_setImage(with: URL(string: recipe.mainUrl), placeholderImage: UIImage(named: "ic_no_image.png"))
        introduction.text = recipe.introduction
    }

}
