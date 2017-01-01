//
//  MatrixInverse.swift
//  SwiftNum
//
//  Created by Donald Pinckney on 1/1/17.
//
//

import Accelerate

public extension Matrix {
    var inverse: Matrix? {
        if width != height {
            return nil
        }
        
        var N = __CLPK_integer(width)
        var error: __CLPK_integer = 0
        
        var mat = self.data
        var pivot = [__CLPK_integer](repeating: 0, count: Int(N))
        var workspace = [Double](repeating: 0, count: Int(N))
        
        dgetrf_(&N, &N, &mat, &N, &pivot, &error)
        
        var res: Matrix? = nil
        if error == 0 {
            dgetri_(&N, &mat, &N, &pivot, &workspace, &N, &error)
            res = Matrix(rowMajorData: mat, width: Int(N))
        }
        
        return res
    }
}
