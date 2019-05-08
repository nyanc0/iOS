//
//  MaterialViewCell.swift
//  GourmetApp
//
//  Created by 福岡　侑里奈 on 2019/05/08.
//  Copyright © 2019 yurina fukuoka. All rights reserved.
//

import UIKit

class MethodViewCell: UITableViewCell {

    @IBOutlet private weak var numLabel: UILabel!
    @IBOutlet weak var methodLabel: UILabel!

    func setData(cookingMethod: CookingMethod) {
        numLabel.text = cookingMethod.procedureNo
        methodLabel.text = cookingMethod.procedure
    }
}
