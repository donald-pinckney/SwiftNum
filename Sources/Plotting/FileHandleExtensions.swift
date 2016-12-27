//
//  FileHandleExtensions.swift
//  SwiftNum
//
//  Created by Donald Pinckney on 12/27/16.
//
//

import Foundation

extension FileHandle: TextOutputStream {
    public func write(_ string: String) {
        write(string.data(using: .utf8)!)
    }
}
