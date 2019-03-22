//
//  AsyncTest.swift
//  GourmetAppTests
//
//  Created by 福岡　侑里奈 on 2019/03/22.
//  Copyright © 2019 yurina fukuoka. All rights reserved.
//

import XCTest
@testable import GourmetApp

class AsyncTest: XCTestCase {
    func testAsync() {
        let expectation = self.expectation(description: "waiting")
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 10)
    }
}
