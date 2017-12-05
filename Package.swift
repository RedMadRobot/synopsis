// swift-tools-version:4.0


import PackageDescription


let package = Package(
    name: "Synopsis",
    products: [
        Product.library(
            name: "Synopsis",
            targets: ["Synopsis"]
        ),
    ],
    dependencies: [
        Package.Dependency.package(
            url: "https://github.com/jpsim/SourceKitten",
            from: "0.18.0"
        ),
    ],
    targets: [
        Target.target(
            name: "Synopsis",
            dependencies: ["SourceKittenFramework"]
        ),
        Target.testTarget(
            name: "SynopsisTests",
            dependencies: ["Synopsis"]
        ),
    ]
)
