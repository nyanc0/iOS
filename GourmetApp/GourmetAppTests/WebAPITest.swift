//
//  WebAPITest.swift
//  GourmetAppTests
//
//  Created by yurina fukuoka on 2019/03/21.
//  Copyright © 2019年 yurina fukuoka. All rights reserved.
//

import XCTest
@testable import GourmetApp

class WebAPITest: XCTestCase {
    func testRequest() {
        let input: Request = (
            url: URL(string: "http://10.0.2.2:3000/recipe")!,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )
        WebAPI.call(with: input)
    }

    func testResponse() {
        let _: Response = (
            statusCode: .oK,
            headers: [:],
            payload: "this is a response text".data(using: .utf8)!
        )
    }
}
