//
//  Optimizer.swift
//  AES-NN
//
//  Created by Donald Pinckney on 1/4/17.
//
//

import Linear

// See: https://en.wikipedia.org/wiki/Gradient_descent
public struct GradientDescentOptimizer {
    let learningRate: Double
    let precision: Double
    let maxIters: UInt
    let debug: Bool
    
    public init(debug: Bool = true, learningRate: Double, precision: Double, maxIterations: UInt = UInt.max) {
        self.learningRate = learningRate
        self.precision = precision
        maxIters = maxIterations
        self.debug = debug
    }
    
    public func optimize(_ toOptimize: Optimizable) -> (costHistory: [Double], parameters: Matrix) {
        var toOptimize = toOptimize
        
        var P_new = toOptimize.initialParameters()
        var P_old = P_new + 2 * precision
        
        var costHistory: [Double] = []
        
        // abs(P_new - P_old) > precision
        var outOfPrecision = true
        var iter: UInt = 0
        while outOfPrecision && iter < maxIters {
            P_old = P_new
            let (cost, deriv) = toOptimize.costFunction(P_old)
            if debug {
                print("Iteration \(iter) | Cost: \(cost)")
            }
            costHistory.append(cost)
            
            P_new -= learningRate * deriv
            
            
            outOfPrecision = false
            if abs(P_new - P_old) > precision {
                outOfPrecision = true
            }
            
            iter += 1
        }
        
        return (costHistory: costHistory, parameters: P_new)
    }
}
