// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftTestTriage",
    products: [.executable(name: "test-triage", targets: ["TestTriageCLI"])],
    targets: [
        .target(name: "TestTriage"),
        .executableTarget(name: "TestTriageCLI", dependencies: ["TestTriage"]),
        .testTarget(name: "TestTriageTests", dependencies: ["TestTriage"]),
    ]
)
