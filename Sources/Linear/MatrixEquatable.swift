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
