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

extension UITableViewCell {
    func shadowAndBorderForCell() {
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
    }
}
