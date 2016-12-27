//
//  XCTestMatrixHelpers.swift
//  SwiftNum
//
//  Created by Donald Pinckney on 12/27/16.
//
//

import XCTest
@testable import Linear

func XCTAssertEqualWithAccuracy(_ X: Matrix, _ Y: Matrix, accuracy: Double, _ message: String = "") {
    XCTAssertEqual(X.width, Y.width)
    XCTAssertEqual(X.height, Y.height)
    
    for r in 0..<X.height {
        for c in 0..<X.width {
            XCTAssertEqualWithAccuracy(X[r, c], Y[r, c], accuracy: accuracy, message)
        }
    }
}

