// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "ChickGen",
    dependencies: [
        .Package(url: "https://github.com/kylef/PathKit.git", majorVersion: 0, minor: 8),
        .Package(url: "https://github.com/kylef/Commander.git", majorVersion: 0, minor: 6)
    ]
)
