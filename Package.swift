import PackageDescription

let package = Package(
    name: "SwiftNum",
    targets: [
    	Target(name: "Linear", dependencies: []),
    	Target(name: "Plotting", dependencies: []),
    	Target(name: "SignalProcessing", dependencies: []),
    	Target(name: "Optimization", dependencies: ["Linear"]),
        Target(name: "GeneralMath", dependencies: [])
    ]
)
