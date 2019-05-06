//
//  FavoriteUseCase.swift
//  GourmetApp
//
//  Created by 福岡　侑里奈 on 2019/03/29.
//  Copyright © 2019 yurina fukuoka. All rights reserved.
//

import Foundation
import RxSwift
class FavoriteListUseCase {

    private let favoriteRepository: FavoriteRepository

    init(favoriteRepository: FavoriteRepository) {
        self.favoriteRepository = favoriteRepository
    }

    func loadFavoriteList() -> Single<[Recipe]> {
        return favoriteRepository.getFavoriteList()
    }

}
