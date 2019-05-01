//
//  DetailNavigator.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/05/01.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation

class DetailNavigator {
    private weak var viewController: ReccomendRecipeListViewController?

    init(viewController: ReccomendRecipeListViewController) {
        self.viewController = viewController
    }

    func toDetail(recipe: Recipe) {
        viewController?.performSegue(withIdentifier: "toRecipeDetailController", sender: recipe)
    }
}
