//
//  MatrixComponentWiseFunction.swift
//  SwiftNum
//
//  Created by Donald Pinckney on 1/1/17.
//
//

import Foundation

public func extendToMatrix(_ f: @escaping (Double) -> Double) -> ((Matrix) -> Matrix) {
    return { mat in
        var res = mat
        res.data = res.data.map(f)
        return res
    }
}

let exp = extendToMatrix(Foundation.exp)
let tanh = extendToMatrix(Foundation.tanh)
