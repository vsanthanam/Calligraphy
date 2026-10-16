// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser

@main
struct Quill: ParsableCommand {
    mutating func run() throws {
        print("Hello, world!")
    }
}
