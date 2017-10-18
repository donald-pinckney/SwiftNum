import XCTest
@testable import Optimization
import Linear

let f: (Double) -> Double = { (x: Double) in x*x*x*x - 3*x*x*x + 2 }
let df: (Double) -> Double = { (x: Double) in 4*x*x*x - 9*x*x }

let f2: (Matrix) -> Double = { (X: Matrix) in
    let x = X[0]
    let y = X[1]
    return x*x*x*x - 3*x*x*x + 2 + y*y*y*y - 3*y*y*y
}
let df2: (Matrix) -> Matrix = { (X: Matrix) in
    let x = X[0]
    let y = X[1]
    var der = Matrix.fill(2, 1, value: 0)
    der[0] = 4*x*x*x - 9*x*x
    der[1] = 4*y*y*y - 9*y*y
    return der
}

class OptimizationTests: XCTestCase {
    

    let wrapper = OptimizableFunctionWrapper(costFunction: f, costDerivative: df, initialParameters: 6)
    let wrapper2 = OptimizableFunctionWrapper(costFunction: f2, costDerivative: df2, initialParameters: Matrix.fill(2, 1, value: 6))

    let gradientDescent = GradientDescentOptimizer(learningRate: 0.01, precision: 0.00001)
    let conjugateGradient = ConjugateGradientOptimizer()
    let expectedXmin = 9.0 / 4.0
    let expectedXmin2 = Matrix.fill(2, 1, value: 9/4)
    let expectedYmin = -6.54296875
    let expectedYmin2 = -15.0859375

    func testGradientDescentOptimizerSingleVariable() {
        let (history, xMin) = gradientDescent.optimize(wrapper)
        let yMin = history.last!
        
        XCTAssertEqual(xMin[0], expectedXmin, accuracy: 0.001)
        XCTAssertEqual(yMin, expectedYmin, accuracy: 0.001)
    }
    
    func testGradientDescentOptimizerMultiVariable() {
        let (history, xMin) = gradientDescent.optimize(wrapper2)
        let yMin = history.last!
        
        XCTAssertEqual(xMin[0], expectedXmin2[0], accuracy: 0.001)
        XCTAssertEqual(xMin[1], expectedXmin2[1], accuracy: 0.001)
        
        XCTAssertEqual(yMin, expectedYmin2, accuracy: 0.001)
    }
    
    func testConjugateGradientOptimizerSingleVariable() {
        let (history, xMin) = conjugateGradient.optimize(wrapper)
        let yMin = history.last!
        
        XCTAssertEqual(xMin[0], expectedXmin, accuracy: 0.001)
        XCTAssertEqual(yMin, expectedYmin, accuracy: 0.001)
    }
    
    func testConjugateGradientOptimizerMultiVariable() {
        let (history, xMin) = conjugateGradient.optimize(wrapper2)
        let yMin = history.last!
        
        XCTAssertEqual(xMin[0], expectedXmin2[0], accuracy: 0.001)
        XCTAssertEqual(xMin[1], expectedXmin2[1], accuracy: 0.001)

        XCTAssertEqual(yMin, expectedYmin2, accuracy: 0.001)
    }
    
    
    static var allTests : [(String, (OptimizationTests) -> () throws -> Void)] {
        return [
            ("testGradientDescentOptimizer", testGradientDescentOptimizerSingleVariable),
            ("testConjugateGradientOptimizer", testGradientDescentOptimizerSingleVariable),
        ]
    }
}
