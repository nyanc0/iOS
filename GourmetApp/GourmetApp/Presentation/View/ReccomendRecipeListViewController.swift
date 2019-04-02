//
//  ReccomendRecipeListViewControllerTableViewController.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/04/01.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import UIKit

class ReccomendRecipeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var reccomendListView: UITableView!
    /// Itemの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    /// Cellに値をセットして返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        if let cell: RecipeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeTableViewCell {
            // セルに表示する値を設定する
            return cell
        }
        return UITableViewCell()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        reccomendListView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
