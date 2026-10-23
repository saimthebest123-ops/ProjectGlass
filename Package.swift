
 // swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ProjectGlass",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "ProjectGlass",
            targets: ["ProjectGlass"]
        )
    ],
    targets: [
        .target(
            name: "ProjectGlass",
            path: ".",
            exclude: ["README.md", "Package.swift"]
        )
    ]
)
