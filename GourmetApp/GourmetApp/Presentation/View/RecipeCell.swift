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
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var reccomendLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            innerView.backgroundColor = UIColor.lightGray
        } else {
            innerView.backgroundColor = UIColor.white
        }
    }

    func setData(recipe: Recipe) {
        recipeImage.sd_setImage(with: URL(string: recipe.mainUrl), placeholderImage: UIImage(named: "ic_no_image.png"))
        introduction.text = recipe.introduction
        if recipe.isReccomend() {
            self.reccomendLabel.isHidden = false
            self.layoutIfNeeded()
        } else {
            self.reccomendLabel.isHidden = true
            self.layoutIfNeeded()
        }
    }

    override func draw(_ rect: CGRect) {
        innerView.layer.borderWidth = 0.5
        innerView.layer.borderColor = UIColor.lightGray.cgColor
        innerView.layer.shadowColor = UIColor.gray.cgColor
        innerView.layer.shadowRadius = 2.0
        innerView.layer.shadowOpacity = 1.0
        innerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        innerView.layer.shadowPath = UIBezierPath(rect: innerView.bounds).cgPath
    }
}
