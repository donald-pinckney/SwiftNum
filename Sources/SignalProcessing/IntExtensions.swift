//
//  IntExtensions.swift
//  SwiftNum
//
//  Created by Donald Pinckney on 12/27/16.
//
//

import Foundation

extension Integer {
    var isPowerOfTwo: Bool {
        return self > 0 && (self & (self - 1)) == 0
    }
}
