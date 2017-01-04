//
//  MatrixPrint.swift
//  SwiftNum
//
//  Created by Donald Pinckney on 1/4/17.
//
//

import Foundation

extension Matrix: CustomStringConvertible {
    public var description: String {
        var final = "\(height) x \(width) matrix:\n"
        for r in 0..<height {
            final += "    "
            for c in 0..<width {
                let num = String(format: "%.4g", self[r, c])
                final += num
                if c != width - 1 {
                    final += repeatElement(" ", count: 10 - num.characters.count).reduce("", +)
                }
            }
            
            if r != height - 1 {
                final += "\n"
            }
        }
        return final
    }
}

extension Matrix: CustomDebugStringConvertible {
    public var debugDescription: String {
        return description
    }
}
