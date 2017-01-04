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

public let exp = extendToMatrix(Foundation.exp)
public let log = extendToMatrix(Foundation.log)
public let sin = extendToMatrix(Foundation.sin)
public let cos = extendToMatrix(Foundation.cos)
public let tan = extendToMatrix(Foundation.tan)
public let sinh = extendToMatrix(Foundation.sinh)
public let cosh = extendToMatrix(Foundation.cosh)
public let tanh = extendToMatrix(Foundation.tanh)
