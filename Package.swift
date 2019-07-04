// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Meitulu",
    products: [
        .executable(name: "Meitulu", targets: ["Meitulu"]),
        .library(name: "MeituluKit", targets: ["MeituluKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/jakeheis/SwiftCLI", from: "5.3.0"),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.0.0"),
        .package(url: "https://github.com/JohnSundell/Files.git", from: "3.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Meitulu",
            dependencies: ["MeituluKit"]),
        .target(
            name: "MeituluKit",
            dependencies: ["SwiftCLI", "SwiftSoup", "Files"]),
        .testTarget(
            name: "MeituluTests",
            dependencies: ["Meitulu"]),
    ]
)
