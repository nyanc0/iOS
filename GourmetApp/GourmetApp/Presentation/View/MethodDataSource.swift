//
//  MethodDataSouece.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/05/09.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources
import RxCocoa

class MethodDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {

    typealias Element = [CookingMethod]
    var itemModels: [CookingMethod] = []

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MethodViewCell", for: indexPath) as? MethodViewCell else {
            fatalError("The dequeued cell is not instance of MealTableViewCell.")
        }
        let element = itemModels[indexPath.row]
        cell.setData(cookingMethod: element)
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
