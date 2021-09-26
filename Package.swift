// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CustomKeyboard",
    products: [
        .library(
            name: "CustomKeyboard",
            targets: ["CustomKeyboard"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "CustomKeyboard",
            dependencies: [],
            resources: [
                .copy("Resources/backspace_ios7_icon.png"),
                .copy("Resources/backspace_ios7_icon@2x.png"),
                .copy("Resources/backspace_ios7_icon@3x.png"),
            ]),
    ]
)
