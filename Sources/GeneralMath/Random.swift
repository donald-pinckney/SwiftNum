//
//  Matrix.swift
//  SwiftNum
//
//  Created by Donald Pinckney on 1/9/17.
//
//

import Foundation

public func random(_ n: Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
}

// Shuffling code thanks to: https://github.com/raywenderlich/swift-algorithm-club

/*
 Copyright (c) 2016 Matthijs Hollemans and contributors
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

public extension Array {
    public mutating func shuffle() {
        for i in stride(from: count - 1, through: 1, by: -1) {
            let j = random(i + 1)
            (self[i], self[j]) = (self[j], self[i])
        }
    }
    
    public func shuffled() -> Array {
        var a = self
        a.shuffle()
        return a
    }
}

public extension CountableRange {
    public func shuffled() -> [Bound] {
        let a = Array(self)
        return a.shuffled()
    }
}

public extension CountableClosedRange {
    public func shuffled() -> [Bound] {
        let a = Array(self)
        return a.shuffled()
    }
}

func randomPermutation(_ n: Int) -> [Int] {
    return (0..<n).shuffled()
}
