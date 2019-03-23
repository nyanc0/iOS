//
//  RecipeRequest.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/03/23.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation

enum RecipeListRequest: BaseRequestProtocol {
    typealias ResponseType = RecipeResponse
    
    var path: APIPath {
        return APIPath.recipe
    }
    var methodAndPayload: HTTPMethodAndPayload {
        return HTTPMethodAndPayload.get
    }
    var queries: [URLQueryItem] {
        return []
    }
}
