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
            url: URL(string: "http://localhost:3000/recipe")!,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )
        WebAPI.call(with: input)
    }
    
    func testResponse() {
        let response: Response = (
            statusCode: .ok,
            headers: [:],
            payload: "this is a response text".data(using: .utf8)!
        )
        
        let recipeAPI = RecipeAPI.init()
        let errorOrSuccess = recipeAPI.from(response: response)
        
        switch errorOrSuccess {
        case let .left(error):
            XCTFail("\(error)")
        case let .right(recipe):
            XCTAssertEqual(recipe.genreCd, "this is a response text")
        }
    }
    
    func testRequestAndResponse() {
        let expectation = self.expectation(description: "Waiting API")
        
        let input: Input = (
            url: URL(string: "http://localhost:3000/recipe")!,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )
        
        WebAPI.call(with: input) { output in
            switch output {
            case let .noResponse(connectionError):
                XCTFail("\(connectionError)")
            case let .hasResponse(response):
                let errorOrSuccess = RecipeAPI.init().from(response: response)
                XCTAssertNotNil(errorOrSuccess.right)
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10)
    }
}
