//
//  LinearPerformanceTests.swift
//  SwiftNum
//
//  Created by Donald Pinckney on 12/27/16.
//
//

import XCTest
@testable import Linear

class LinearPerformanceTests: XCTestCase {

    func testMatrixMultiplyPerformance() {

        let n = 2000
        let X = Matrix.random(n, n)

        self.measure {
            let _ = X * X
        }
    }
    
    static var allTests : [(String, (LinearPerformanceTests) -> () throws -> Void)] {
        return [
            ("testMatrixMultiplyPerformance", testMatrixMultiplyPerformance),
        ]
    }

}
