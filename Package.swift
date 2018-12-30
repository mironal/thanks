// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Thanks",
    products: [
        .library(name: "ThanksKit", targets: ["ThanksKit"]),
        .executable(name: "Thanks", targets: ["Thanks"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0"),
        .package(url: "https://github.com/antitypical/Result", from: "4.1.0"),
        .package(url: "https://github.com/apple/swift-package-manager", from: "0.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ThanksKit",
            dependencies: []
        ),
        .target(
            name: "Thanks",
            dependencies: ["ThanksKit", "Rainbow", "Result", "Utility"]
        ),
        .testTarget(
            name: "ThanksKitTests",
            dependencies: ["ThanksKit"]
        ),
        .testTarget(
            name: "ThanksTests",
            dependencies: ["Thanks"]
        ),
    ],
    swiftLanguageVersions: [.v4_2]
)
