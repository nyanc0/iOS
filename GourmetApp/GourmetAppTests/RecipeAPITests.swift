//
//  RecipeAPITests.swift
//  GourmetAppTests
//
//  Created by 福岡　侑里奈 on 2019/03/22.
//  Copyright © 2019 yurina fukuoka. All rights reserved.
//

import XCTest
@testable import GourmetApp

//class RecipeAPITest: XCTestCase {
//    func testFetch() {
//        let expectation = self.expectation(description: "API")
//        let input: Input = (
//            url: URL(string: "http://localhost:3000/recipe")!,
//            queries: [],
//            headers: [:],
//            methodAndPayload: .get
//        )
//
//        WebAPI.call(with: input) { output in
//            switch output {
//            case .noResponse:
//                XCTFail("No response")
//            case let .hasResponse(response):
//                let errorOrSuccess = RecipeAPI.init().from(response: response)
//                XCTAssertNotNil(errorOrSuccess.right)
//            }
//            expectation.fulfill()
//        }
//        self.waitForExpectations(timeout: 10)
//    }
//}
