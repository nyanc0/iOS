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

    @IBOutlet weak var callStack: UIStackView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var reccomendLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(row: IndexPath) {
        introductionLabel.text = String(row.row)
        mainImageView.sd_setImage(with: URL(string: "http://localhost:3000/assets/images/recipe_001.png"), placeholderImage: UIImage(named: "ic_no_image.png"))
    }
    
}
