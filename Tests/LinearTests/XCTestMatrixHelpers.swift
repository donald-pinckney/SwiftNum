//
//  XCTestMatrixHelpers.swift
//  SwiftNum
//
//  Created by Donald Pinckney on 1/7/17.
//
//

import XCTest
import Linear

public func XCTAssertEqualWithAccuracy(_ X: Matrix, _ Y: Matrix, accuracy: Double, _ message: String = "") {
    XCTAssertEqual(X.width, Y.width)
    XCTAssertEqual(X.height, Y.height)
    
    for r in 0..<X.height {
        for c in 0..<X.width {
            XCTAssertEqualWithAccuracy(X[r, c], Y[r, c], accuracy: accuracy, message)
        }
    }
}
    
