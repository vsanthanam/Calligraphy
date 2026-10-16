import ArgumentParser
import Calligraphy
import Foundation
import Manuscript

@main
struct Quill: AsyncParsableCommand {

    @Argument(help: "Path to a Manuscript spec.")
    var spec: String

    @Option(help: "Directory to write the generated package into.")
    var output = "."

    @Option(help: "Access level of the generated declarations.")
    var accessLevel: AccessLevel = .internal

    @Flag(name: .shortAndLong, help: "Replace an existing package in the output directory.")
    var force = false

    mutating func run() async throws {
        let specURL = URL(filePath: spec)
        let service = try Service(contentsOf: specURL)
        let destination = URL(filePath: output, directoryHint: .isDirectory)
        try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: true)
        let package = GeneratedPackage(service: service, specFileName: specURL.lastPathComponent)
            .environment(\.accessLevel, accessLevel)
        let written = try await package.write(to: destination, shouldOverwrite: force)
        for url in written {
            print(url.path(percentEncoded: false))
        }
    }

}
