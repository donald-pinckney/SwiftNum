// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftNum",
    targets: [
    	.target(name: "Linear", dependencies: []),
    	.target(name: "Plotting", dependencies: []),
    	.target(name: "SignalProcessing", dependencies: []),
    	.target(name: "Optimization", dependencies: ["Linear"]),
        .target(name: "GeneralMath", dependencies: [])
    ]
)
