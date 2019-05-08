//
//  IngredientDataSource.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/05/08.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources
import RxCocoa

class IngredientDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {

    typealias Element = [CookingIngredients]
    var itemModels: [CookingIngredients] = []

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientViewCell", for: indexPath) as? IngredientViewCell else {
            fatalError("The dequeued cell is not instance of MealTableViewCell.")
        }
        let element = itemModels[indexPath.row]
        cell.setData(cookingIngredients: element)
        return cell
    }

    func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        Binder(self) { dataSource, element in
            dataSource.itemModels = element
            tableView.reloadData()
            }
            .on(observedEvent)
    }
}
