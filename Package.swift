// swift-tools-version: 5.10
import PackageDescription


let package = Package(
    name: "LoadingViewKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "LoadingViewKit", targets: ["LoadingViewKit"])
    ],
    targets: [
        .target(
            name: "LoadingViewKit",
            path: "Sources/LoadingViewKit"
        )
    ]
)
