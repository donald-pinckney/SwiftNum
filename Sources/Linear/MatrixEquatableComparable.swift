//
//  MatrixEquatable.swift
//  SwiftNum
//
//  Created by Donald Pinckney on 1/1/17.
//
//

extension Matrix: Equatable {
    public static func ==(lhs: Matrix, rhs: Matrix) -> Bool {
        return lhs.width == rhs.width && lhs.data == rhs.data
    }
}

extension Matrix: Comparable {
    public static func <(lhs: Matrix, rhs: Matrix) -> Bool {
        precondition(lhs.width == rhs.width)
        precondition(lhs.height == rhs.height)
        
        var result = true
        for (d1, d2) in zip(lhs.data, rhs.data) {
            result = result && (d1 < d2)
        }
        return result
    }
}
