//
//  Optimizable.swift
//  SwiftNum
//
//  Created by Donald Pinckney on 1/4/17.
//
//

import Linear

public protocol Optimizable {
    mutating func costFunction(_ P: Matrix) -> (cost: Double, derivative: Matrix)
    func initialParameters() -> Matrix
}

public struct OptimizableFunctionWrapper: Optimizable {
    public func costFunction(_ P: Matrix) -> (cost: Double, derivative: Matrix) {
        return (cost: wrappedCostFunction(P), derivative: wrappedCostDerivative(P))
    }
    
    public func initialParameters() -> Matrix {
        return initParams
    }
    
    private let wrappedCostFunction: (Matrix) -> Double
    private let wrappedCostDerivative: (Matrix) -> Matrix
    private let initParams: Matrix
    
    
    init(costFunction: @escaping (Matrix) -> Double, costDerivative: @escaping (Matrix) -> Matrix, initialParameters: Matrix) {
        wrappedCostFunction = costFunction
        wrappedCostDerivative = costDerivative
        initParams = initialParameters
    }
    init(costFunction: (f: (Matrix) -> Double, df: (Matrix) -> Matrix), initialParameters: Matrix) {
        self.init(costFunction: costFunction.f, costDerivative: costFunction.df, initialParameters: initialParameters)
    }
    
    
    init(costFunction: @escaping (Double) -> Double, costDerivative: @escaping (Double) -> Double, initialParameters: Double) {
        self.init(costFunction: { mat in return costFunction(mat[0]) },
                  costDerivative: { mat in return Matrix.fill(1, 1, value: costDerivative(mat[0])) },
                  initialParameters: Matrix.fill(1, 1, value: initialParameters))
    }
    
    init(costFunction: (f: (Double) -> Double, df: (Double) -> Double), initialParameters: Double) {
        self.init(costFunction: costFunction.f, costDerivative: costFunction.df, initialParameters: initialParameters)
    }
}

