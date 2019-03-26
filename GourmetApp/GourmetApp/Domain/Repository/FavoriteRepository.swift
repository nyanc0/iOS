//
//  FavoriteRepository.swift
//  GourmetApp
//
//  Created by 福岡　侑里奈 on 2019/03/26.
//  Copyright © 2019 yurina fukuoka. All rights reserved.
//

import Foundation
import RxSwift
protocol FavoriteRepository {
    func getFavoriteList() -> Single<[Recipe]>
    func insert(recipe: Recipe) -> Single<Void>
    func delete(recipeId: String) -> Single<Void>
}
