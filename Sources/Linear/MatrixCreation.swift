//
//  MatrixCreation.swift
//  SwiftNum
//
//  Created by Donald Pinckney on 1/1/17.
//
//

public extension Matrix {
    static func zeros(_ height: Int, _ width: Int) -> Matrix {
        return Matrix(rowMajorData: [Double](repeating: 0, count: width*height), width: width)
    }
    
    static func I(_ n: Int) -> Matrix {
        var data = [Double](repeating: 0, count: n*n)
        for r in 0..<n {
            data[r*n + r] = 1
        }
        return Matrix(rowMajorData: data, width: n)
    }
}
