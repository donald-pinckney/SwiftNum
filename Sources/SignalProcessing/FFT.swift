//
//  FFT.swift
//  SwiftNum
//
//  Created by Donald Pinckney on 12/27/16.
//
//

import Foundation
import Accelerate

private var fft_setup: vDSP_DFT_SetupD! = nil
private var fft_currentLength: Int = 0

func fft_set_length(_ length: Int) {
    fft_currentLength = length
    fft_setup = vDSP_DFT_zrop_CreateSetupD(nil, vDSP_Length(2 * length), vDSP_DFT_Direction.FORWARD)!
}


func fft(_ inputArray: [Double]) -> [(magnitude: Double, phase: Double)] {
    let length = inputArray.count
    precondition(length.isPowerOfTwo)
    
    if length != fft_currentLength {
        vDSP_DFT_DestroySetupD(fft_setup)
        fft_set_length(length)
    }
    



    let zeroArray = [Double](repeating:0.0, count:length)
    
    var outputReal = [Double](repeating:0.0, count: length)
    var outputImag = [Double](repeating:0.0, count: length)
    
    vDSP_DFT_ExecuteD(fft_setup,
                      inputArray,
                      zeroArray,
                      &outputReal,
                      &outputImag)
    
    
    var outputCombined = [Double](repeating: 0.0, count: length)
    cblas_dcopy(Int32(length / 2), outputReal, 1, &outputCombined, 2)
    cblas_dcopy(Int32(length / 2), outputImag, 1, &outputCombined + 1, 2)
    
    var normFactor = 1.0 / Double(length)
    vDSP_vsmulD(outputCombined, vDSP_Stride(1), &normFactor, &outputCombined, vDSP_Stride(1), vDSP_Length(length))
    
    var polarCombined = [Double](repeating: 0.0, count: length)
    vDSP_polarD(outputCombined, 2, &polarCombined, 2, vDSP_Length(length / 2))

    let polarPtr = UnsafeRawPointer(polarCombined)
    let polarTuplePtr = polarPtr.assumingMemoryBound(to: (magnitude: Double, phase: Double).self)
    let polarTupleBufferPtr = UnsafeBufferPointer<(magnitude: Double, phase: Double)>(start: polarTuplePtr, count: length / 2)
    
    return Array(polarTupleBufferPtr)
}
