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
    
    public init(learningRate: Double, precision: Double, maxIterations: UInt = UInt.max) {
        self.learningRate = learningRate
        self.precision = precision
        maxIters = maxIterations
    }
    
    public func optimize(_ toOptimize: Optimizable) -> (costHistory: [Double], parameters: [Matrix]) {
        var toOptimize = toOptimize
        
        var P_new = toOptimize.initialParameters()
        var P_old = P_new.map { $0 + 2 * precision } // The value does not matter as long as abs(x_new - x_old) > precision
        
        var costHistory: [Double] = []
        
        // abs(P_new - P_old) > precision
        var outOfPrecision = true
        var iter: UInt = 0
        while outOfPrecision && iter < maxIters {
            P_old = P_new
            let (cost, deriv) = toOptimize.costFunction(P_old)
            costHistory.append(cost)
            
            for i in 0..<P_new.count {
                P_new[i] -= learningRate * deriv[i]
            }
            
            
            outOfPrecision = false
            for (Pm_new, Pm_old) in zip(P_new, P_old) {
                if abs(Pm_new - Pm_old) > precision {
                    outOfPrecision = true
                    break
                }
            }
            
            iter += 1
        }
        
        return (costHistory: costHistory, parameters: P_new)
    }
}
