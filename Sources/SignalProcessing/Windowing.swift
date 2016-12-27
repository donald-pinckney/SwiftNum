//
//  Windowing.swift
//  SwiftNum
//
//  Created by Donald Pinckney on 12/27/16.
//
//

import Accelerate

typealias WindowFunction = ([Double]) -> [Double]

let blackman = applyWindow(makeWindow: makeVDSPWindow(vDSP_blkman_windowD))
let hanning = applyWindow(makeWindow: makeVDSPWindow(vDSP_hann_windowD))
let hamming = applyWindow(makeWindow: makeVDSPWindow(vDSP_hamm_windowD))
let rectangle = applyWindow(makeWindow: makeRectangle)



private func applyWindow(makeWindow: @escaping (inout [Double]) -> Void) -> WindowFunction {
    return { x in
        let n = x.count
        let len = vDSP_Length(n)
        
        var window = [Double](repeating: 0, count: n)
        makeWindow(&window)
        
        var result = [Double](repeating: 0, count: n)
        
        vDSP_vmulD(x, 1, window, 1, &result, 1, len)
        
        return result
    }
}

typealias vDSPWindow = (UnsafeMutablePointer<Double>, vDSP_Length, Int32) -> Void

private func makeVDSPWindow(_ vDSPFunc: @escaping vDSPWindow) -> (inout [Double]) -> Void {
    return { window in
        let len = vDSP_Length(window.count)
        
        vDSPFunc(&window, len, 0);
    }
}

private func makeRectangle(_ window: inout [Double]) -> Void {
    var one = 1.0
    let len = vDSP_Length(window.count)

    vDSP_vfillD(&one, &window, 1, len)
}
