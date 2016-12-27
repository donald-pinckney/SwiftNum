//
//  Matrix.swift
//  SwiftNum
//
//  Created by Donald Pinckney on 12/27/16.
//
//

import Accelerate

public struct Matrix {
    
    fileprivate var data: [Double]
    public let width: Int
    public let height: Int
    
    public init(rowMajorData: [Double], width: Int) {
        precondition(rowMajorData.count % width == 0)
        
        data = rowMajorData
        self.width = width
        self.height = rowMajorData.count / width
    }
    
    public init(_ rows: [[Double]]) {
        height = rows.count
        if height > 0 {
            width = rows[0].count
        } else {
            width = 0
        }
        
        data = []
        for r in rows {
            assert(r.count == width)
            data.append(contentsOf: r)
        }
    }
    
    public func inverse() -> Matrix? {
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

// Matrix subscripting
public extension Matrix {
    public subscript(row: Int, column: Int) -> Double {
        get {
            return data[width*row + column]
        }
        set(val) {
            data[width*row + column] = val
        }
    }
    
    public subscript(rows: Range<Int>, columns: Range<Int>) -> Matrix {
        get {
            let width = columns.count
            let height = rows.count
            var values: [Double] = [Double](repeating: 0, count: width * height)
            
            for r in rows.lowerBound..<rows.upperBound {
                let base = (r - rows.lowerBound) * width
                let selfBase = r * self.width + columns.lowerBound
                let selfEnd = r * self.width + columns.upperBound
                values[base..<(base + width)] = data[selfBase..<selfEnd]
            }
            return Matrix(rowMajorData: values, width: width)
        }
        set(subMatrix) {
            precondition(rows.count == subMatrix.height)
            precondition(columns.count == subMatrix.width)
            
            let width = columns.count
            
            for r in rows.lowerBound..<rows.upperBound {
                let base = (r - rows.lowerBound) * width
                let selfBase = r * self.width + columns.lowerBound
                let selfEnd = r * self.width + columns.upperBound
                data[selfBase..<selfEnd] = subMatrix.data[base..<(base + width)]
            }
        }
    }
    public subscript(rows: ClosedRange<Int>, columns: Range<Int>) -> Matrix {
        get {
            return self[Range(rows), columns]
        }
        set(m) {
            self[Range(rows), columns] = m
        }
    }
    public subscript(rows: Range<Int>, columns: ClosedRange<Int>) -> Matrix {
        get {
            return self[rows, Range(columns)]
        }
        set(m) {
            self[rows, Range(columns)] = m
        }
    }
    public subscript(rows: ClosedRange<Int>, columns: ClosedRange<Int>) -> Matrix {
        get {
            return self[Range(rows), Range(columns)]
        }
        set(m) {
            self[Range(rows), Range(columns)] = m
        }
    }
}

// Matrix creation
public extension Matrix {
    static func zeros(_ height: Int, _ width: Int) -> Matrix {
        return Matrix(rowMajorData: [Double](repeating: 0, count: width*height), width: width)
    }
    
    static func I(_ n: Int) -> Matrix {
        var data = [Double](repeating: 0, count: n*n)
        for r in 0..<n {
            data[r*n + r] = 1
        }
        return Matrix(rowMajorData: data, width: n)
    }
}

// Matrix addition
public extension Matrix {
    static func +(lhs: Matrix, rhs: Matrix) -> Matrix {
        precondition(lhs.width == rhs.width)
        precondition(lhs.height == rhs.height)
        
        var res = lhs
        
        vDSP_vaddD(res.data, 1, rhs.data, 1, &res.data, 1, vDSP_Length(lhs.width * rhs.width))
        
        return res
    }
    static func +=(lhs: inout Matrix, rhs: Matrix) {
        precondition(lhs.width == rhs.width)
        precondition(lhs.height == rhs.height)
        
        
        vDSP_vaddD(lhs.data, 1, rhs.data, 1, &lhs.data, 1, vDSP_Length(lhs.width * rhs.width))
    }
    
    
    static func +(lhs: Matrix, rhs: Double) -> Matrix {
        var res = lhs
        var rhs = rhs
        vDSP_vsaddD(res.data, 1, &rhs, &res.data, 1, vDSP_Length(lhs.data.count))
        return res
    }
    static func +(lhs: Double, rhs: Matrix) -> Matrix {
        return rhs + lhs
    }
    static func +=(lhs: inout Matrix, rhs: Double) {
        var rhs = rhs
        vDSP_vsaddD(lhs.data, 1, &rhs, &lhs.data, 1, vDSP_Length(lhs.data.count))
    }
}

// Matrix multiplication
public extension Matrix {
    static func *(lhs: Matrix, rhs: Matrix) -> Matrix {
        precondition(lhs.width == rhs.height)
        
        var res = Matrix.zeros(lhs.height, rhs.width)
        
        vDSP_mmulD(lhs.data, 1, rhs.data, 1, &res.data, 1, vDSP_Length(lhs.height), vDSP_Length(rhs.width), vDSP_Length(lhs.width))
        
        return res
    }
    static func *=(lhs: inout Matrix, rhs: Matrix) {
        lhs = lhs * rhs
    }
    
    
    static func *(lhs: Matrix, rhs: Double) -> Matrix {
        var res = lhs
        var rhs = rhs
        vDSP_vsmulD(res.data, 1, &rhs, &res.data, 1, vDSP_Length(lhs.data.count))
        return res
    }
    static func *(lhs: Double, rhs: Matrix) -> Matrix {
        return rhs * lhs
    }
    static func *=(lhs: inout Matrix, rhs: Double) {
        var rhs = rhs
        vDSP_vsmulD(lhs.data, 1, &rhs, &lhs.data, 1, vDSP_Length(lhs.data.count))
    }
}

extension Matrix: Equatable {
    public static func ==(lhs: Matrix, rhs: Matrix) -> Bool {
        return lhs.width == rhs.width && lhs.data == rhs.data
    }
}

public protocol MatrixOrDouble { } // Don't use this for anything else!

extension Matrix: MatrixOrDouble { }
extension Double: MatrixOrDouble { }

// Matrix concatenation
public extension Matrix {
    static func horizontalConcatenate(_ items: [MatrixOrDouble]) -> Matrix {
        var width = 0
        var height = -1
        for i in items {
            if let m = i as? Matrix {
                width += m.width
                if height != 1 && height != -1 && m.height != height {
                    fatalError("Can not horizontally concatenate matrices of different heights")
                }
                height = m.height
            } else {
                width += 1
                if height < 1 {
                    height = 1
                }
            }
        }
        
        var resData = [Double](repeating: 0, count: width * height)
        for r in 0..<height {
            var c = 0
            for i in items {
                let base = r*width + c
                let itemWidth: Int
                if let m = i as? Matrix {
                    itemWidth = m.width
                    resData[base..<(base + itemWidth)] = m.data[r*m.width..<((r + 1)*m.width)]
                } else {
                    let d = i as! Double
                    itemWidth = 1
                    resData[base] = d
                }
                
                c += itemWidth
            }
        }
        
        return Matrix(rowMajorData: resData, width: width)
    }
    
    static func verticalConcatenate(_ items: [MatrixOrDouble]) -> Matrix {
        var width = -1
        var height = 0
        for i in items {
            if let m = i as? Matrix {
                height += m.height
                if width != 1 && width != -1 && m.width != width {
                    fatalError("Can not vertically concatenate matrices of different width")
                }
                width = m.width
            } else {
                height += 1
                if width < 1 {
                    width = 1
                }
            }
        }
        
        var resData = [Double](repeating: 0, count: width * height)
        var idx = 0
        for i in items {
            let len: Int
            if let m = i as? Matrix {
                len = m.width * m.height
                resData[idx..<(idx+len)] = m.data[0..<m.data.count]
            } else {
                let d = i as! Double
                len = width
                resData[idx..<(idx+len)] = [Double](repeating: d, count: width)[0..<width]
            }
            idx += len
        }
        
        return Matrix(rowMajorData: resData, width: width)
    }
    
    init(_ format: [[MatrixOrDouble]]) {
        let rows = format.map(Matrix.horizontalConcatenate)
        let m = Matrix.verticalConcatenate(rows)
        data = m.data
        width = m.width
        height = m.height
    }
}
