/*
 Minimize a continuous differentialble multivariate function. Starting point
 is given by "X" (D by 1), and the function named in the string "f", must
 return a function value and a vector of partial derivatives. The Polack-
 Ribiere flavour of conjugate gradients is used to compute search directions,
 and a line search using quadratic and cubic polynomial approximations and the
 Wolfe-Powell stopping criteria is used together with the slope ratio method
 for guessing initial step sizes. Additionally a bunch of checks are made to
 make sure that exploration is taking place and that extrapolation will not
 be unboundedly large. The "length" gives the length of the run: if it is
 positive, it gives the maximum number of line searches, if negative its
 absolute gives the maximum allowed number of function evaluations. You can
 (optionally) give "length" a second component, which will indicate the
 reduction in function value to be expected in the first line-search (defaults
 to 1.0). The function returns when either its length is up, or if no further
 progress can be made (ie, we are at a minimum, or so close that due to
 numerical problems, we cannot get any closer). If the function terminates
 within a few iterations, it could be an indication that the function value
 and derivatives are not consistent (ie, there may be a bug in the
 implementation of your "f" function). The function returns the found
 solution "X", a vector of function values "fX" indicating the progress made
 and "i" the number of iterations (line searches or function evaluations,
 depending on the sign of "length") used.
 
 Usage: [X, fX, i] = fmincg(f, X, options, P1, P2, P3, P4, P5)
 
 See also: checkgrad
 
 Copyright (C) 2001 and 2002 by Carl Edward Rasmussen. Date 2002-02-13
 
 
 (C) Copyright 1999, 2000 & 2001, Carl Edward Rasmussen
 
 Permission is granted for anyone to copy, use, or modify these
 programs and accompanying documents for purposes of research or
 education, provided this copyright notice is retained, and note is
 made of any changes that have been made.
 
 These programs and documents are distributed without any warranty,
 express or implied.  As the programs were written for research
 purposes only, they have not been tested to the degree that would be
 advisable in any important application.  All use of these programs is
 entirely at the user's own risk.
 
 SwiftLearn Changes Made:
 1) Rewrite into Swift
 
 */

import Linear
import Foundation

// See: https://en.wikipedia.org/wiki/Conjugate_gradient_method,
// https://www.mathworks.com/matlabcentral/fileexchange/42770-logistic-regression-with-regularization-used-to-classify-hand-written-digits/content/Logistic%20Regression%20with%20regularisation/fmincg.m
public struct ConjugateGradientOptimizer {
    let length: Int
    let red: Double
    
    public init(maxIterations: Int = 100, expectedFirstReduction: Double = 1.0) {
        length = maxIterations
        red = expectedFirstReduction
    }
    
    public func optimize(_ toOptimize: Optimizable) -> (costHistory: [Double], parameters: Matrix) {
        var toOptimize = toOptimize
        
        // a bunch of constants for line searches
        let rho = 0.01
        let sig = 0.5 // RHO and SIG are the constants in the Wolfe-Powell conditions
        let int = 0.1 // don't reevaluate within 0.1 of the limit of the current bracket
        let ext = 3.0 // extrapolate maximum 3 times the current bracket
        let maxEvals = 20 // max 20 function evaluations per line search
        let ratio = 100.0 // maximum allowed slope ratio
        
        var i = 0 // zero the run length counter
        var lsFailed = false // no previous line search has failed
        var history: [Double] = []
        var X = toOptimize.initialParameters()
        
        
        var (f1, df1) = toOptimize.costFunction(X) // get function value and gradient
        
        i += length < 0 ? 1 : 0 // count epochs?!
        var s = -df1 // search direction is steepest
        var d1 = (-s.T * s)[0] // this is the slope
        var z1 = red / (1 - d1) // initial step is red/(|s|+1)
        
        while i < abs(length) { // while not finished
            i += length > 0 ? 1 : 0 // count iterations?!
            
            let X0 = X, f0 = f1, df0 = df1 // make a copy of current values
            
            X += z1 * s // begin line search
            var (f2, df2) = toOptimize.costFunction(X)
            i += length < 0 ? 1 : 0
            
            var d2 = (df2.T * s)[0]
            var f3 = f1, d3 = d1, z3 = -z1 // initialize point 3 equal to point 1
            
            var M = length > 0 ? maxEvals : min(maxEvals, -length - i)
            var success = false, limit = -1.0 // initialize quantities
            
            while true {
                while ((f2 > f1+z1*rho*d1) || (d2 > -sig*d1)) && (M > 0) {
                    limit = z1 // tighten the bracket
                    var z2: Double
                    if f2 > f1 {
                        z2 = z3 - (0.5 * d3 * z3 * z3) / (d3 * z3 + f2 - f3) // quadratic fit
                    } else {
                        let A = 6 * (f2 - f3) / z3 + 3 * (d2 + d3) // cubic fit
                        let B = 3 * (f3 - f2) - z3 * (d3 + 2 * d2)
                        z2 = (sqrt(B * B - A * d2 * z3 * z3) - B) / A // numerical error possible - ok!
                    }
                    
                    if z2.isNaN || z2.isInfinite {
                        z2 = z3 / 2 // if we had a numerical problem then bisect
                    }
                    
                    z2 = max(min(z2, int * z3), (1 - int) * z3) // don't accept too close to limits
                    z1 += z2 // update the step
                    X += z2 * s
                    
                    (f2, df2) = toOptimize.costFunction(X)
                    M -= 1
                    i += length < 0 ? 1 : 0 // count epochs?!
                    d2 = (df2.T * s)[0]
                    z3 -= z2 // z3 is now relative to the location of z2
                }
                
                if f2 > (f1 + z1 * rho * d1) || (d2 > -sig * d1) {
                    break // this is a failure
                } else if d2 > sig * d1 {
                    success = true
                    break
                } else if M == 0 {
                    break // failure
                }
                
                let A = 6 * (f2 - f3) / z3 + 3 * (d2 + d3) // make cubic extrapolation
                let B = 3 * (f3 - f2) - z3 * (d3 + 2 * d2)
                var z2 = -d2 * z3 * z3 / (B + sqrt(B * B - A * d2 * z3 * z3)) // num. error possible - ok!
                if z2.isNaN || z2.isInfinite || z2 < 0 { // num prob or wrong sign?
                    if limit < -0.5 { // if we have no upper limit
                        z2 = z1 * (ext - 1) // then extrapolate the maximum amount
                    } else {
                        z2 = (limit - z1) / 2 // otherwise bisect
                    }
                } else if (limit > -0.5) && (z2 + z1 > limit) { // extraplation beyond max?
                    z2 = (limit - z1) / 2 // bisect
                } else if (limit < -0.5) && (z2 + z1 > z1 * ext) { // extrapolation beyond limit
                    z2 = z1 * (ext - 1.0) // set to extrapolation limit
                } else if z2 < -z3 * int {
                    z2 = -z3 * int
                } else if (limit > -0.5) && (z2 < (limit - z1) * (1.0 - int)) { // too close to limit?
                    z2 = (limit - z1) * (1.0 - int);
                }
                
                f3 = f2  // set point 3 equal to point 2
                d3 = d2
                z3 = -z2
                
                z1 += z2 // update current estimates
                X += z2 * s
                
                (f2, df2) = toOptimize.costFunction(X)
                M -= 1
                i += length < 0 ? 1 : 0 // count epochs?!
                d2 = (df2.T * s)[0]
            } // end of line search
            
            if success { // if line search succeeded
                f1 = f2
                history.append(f1)
                print("Iteration \(i) | Cost: \(f1)")
                s = ((df2.T * df2)[0] - (df1.T * df2)[0]) / ((df1.T * df1)[0]) * s - df2 // Polak-Ribère direction
                (df1, df2) = (df2, df1) // swap derivatives
                d2 = (df1.T * s)[0]
                
                if d2 > 0 { // new slope must be negative
                    s = -df1 // otherwise use steepest direction
                    d2 = -((s.T * s)[0])
                }
                
                z1 *= min(ratio, d1 / (d2 - .leastNormalMagnitude)) // slope ratio but max RATIO
                d1 = d2
                lsFailed = false // this line search did not fail
            } else {
                X = X0 // restore point from before failed line search
                f1 = f0
                df1 = df0
                if lsFailed || i > abs(length) { // line search failed twice in a row
                    break // or we ran out of time, so we give up
                }
                
                (df1, df2) = (df2, df1) // swap derivatives
                s = -df1 // try steepest
                d1 = -((s.T * s)[0])
                z1 = 1 / (1 - d1)
                lsFailed = true
            }
        }
        
        return (history, X)
    }
}

