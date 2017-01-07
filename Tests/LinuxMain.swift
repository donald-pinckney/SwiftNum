import XCTest
@testable import LinearTests

XCTMain([
    testCase(LinearTests.allTests),
    testCase(LinearPerformanceTests.allTeset),
    testCase(OptimizationTests.allTests)
])
