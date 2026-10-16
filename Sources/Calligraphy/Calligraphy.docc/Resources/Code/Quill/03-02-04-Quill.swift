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

    mutating func run() async throws {
        let service = try Service(contentsOf: URL(filePath: spec))
        print(String(ClientDeclaration(service: service)))
    }

}
