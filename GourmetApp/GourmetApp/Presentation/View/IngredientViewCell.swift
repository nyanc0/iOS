//
//  IngredientViewCell.swift
//  GourmetApp
//
//  Created by 福岡　侑里奈 on 2019/05/08.
//  Copyright © 2019 yurina fukuoka. All rights reserved.
//

import UIKit

class IngredientViewCell: UITableViewCell {

    @IBOutlet private weak var materialLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!

    func setData(cookingIngredients: CookingIngredients) {
        materialLabel.text = cookingIngredients.material
        quantityLabel.text = cookingIngredients.quantity
    }
}
