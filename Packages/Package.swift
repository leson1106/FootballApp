// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FootballApp",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "AWSService",
            targets: ["AWSService"]),
        .library(
            name: "Domain",
            targets: ["Domain"]),
        .library(
            name: "MatchRepository",
            targets: ["MatchRepository"]),
        .library(
            name: "MatchUseCase",
            targets: ["MatchUseCase"]),
        .library(
            name: "TeamRepository",
            targets: ["TeamRepository"]),
        .library(
            name: "TeamUseCase",
            targets: ["TeamUseCase"]),
        .library(
            name: "CoreDataRepository",
            targets: ["CoreDataRepository"]),
    ],
    targets: [
        .target(
            name: "AWSService"
        ),
        .target(
            name: "Domain"
        ),
        .target(
            name: "MatchRepository",
            dependencies: [
                "AWSService",
                "Domain"
            ]
        ),
        .target(
            name: "MatchUseCase",
            dependencies: [
                "MatchRepository",
                "CoreDataRepository"
            ]
        ),
        .target(
            name: "TeamRepository",
            dependencies: [
                "AWSService",
                "Domain"
            ]
        ),
        .target(
            name: "TeamUseCase",
            dependencies: [
                "TeamRepository",
                "CoreDataRepository"
            ]
        ),
        .target(
            name: "CoreDataRepository",
            dependencies: [
                "Domain"
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
