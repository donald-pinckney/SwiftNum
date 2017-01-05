//
//  Plotting.swift
//  SwiftNum
//
//  Created by Donald Pinckney on 12/27/16.
//
//

import Foundation


public func plot(_ xs: [Double], toFile: String? = nil) {
    let plotCommand = "plot '<cat' with lines"
    let code: String
    if let file = toFile {
        code = "set terminal png; set output \"\(file)\";" + plotCommand
    } else {
        code = plotCommand
    }
    
    let inputPipe = Pipe()
    var inputFile = inputPipe.fileHandleForWriting
    
    
    let gnuplot = Process()
    gnuplot.launchPath = "/usr/local/bin/gnuplot"
    gnuplot.arguments = ["-p", "-e", code]
    gnuplot.standardInput = inputPipe
    gnuplot.launch()
    
    
    let plotData = xs.map { $0.description }.joined(separator: "\n")
    print(plotData, to: &inputFile)
    inputFile.closeFile()
}
