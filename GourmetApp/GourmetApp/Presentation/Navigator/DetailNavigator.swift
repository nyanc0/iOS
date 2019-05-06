//
//  DetailNavigator.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/05/01.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import UIKit

class DetailNavigator {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func toDetail(recipe: Recipe? = nil) {
        viewController?.performSegue(withIdentifier: "toRecipeDetailController", sender: recipe)
    }
}
