//
//  CookingMethod.swift
//  GourmetApp
//
//  Created by yurina fukuoka on 2019/03/20.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import Foundation
struct CookingMethod: Codable {
    let procedureNo: String
    let procedure: String

    enum CodingKeys: String, CodingKey {
        case procedureNo = "procedure_no"
        case procedure = "procedure"
    }
}
