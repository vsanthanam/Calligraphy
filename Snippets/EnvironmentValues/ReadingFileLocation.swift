// Read where a file is being written with `@FilePath`, `@FileURL`, `@EnclosingPath`, and `@EnclosingURL`.

// snippet.hide
import Calligraphy
import Foundation

// snippet.show
// snippet.path
struct GeneratedNotice: StringComponent {

    @FilePath
    private var path

    @EnclosingPath
    private var folder

    var body: some StringComponent {
        "// \(path ?? "unknown") is generated. Do not edit."
        "// Sibling files live in \(folder ?? "unknown")/"
    }

}

let sources = Folder("Sources") {
    Folder("Models") {
        File("User.swift") {
            GeneratedNotice()
            "struct User {}"
        }
    }
}
// Sources/Models/User.swift begins with:
// // Sources/Models/User.swift is generated. Do not edit.
// // Sibling files live in Sources/Models/
// snippet.end

// snippet.url
struct AbsoluteNotice: StringComponent {

    @FileURL
    private var url

    var body: some StringComponent {
        if let url {
            "// Written to \(url.path(percentEncoded: false))"
        } else {
            "// Not written to disk"
        }
    }

}
// snippet.end

// snippet.enclosing
struct Manifest: Directory {

    let name: String

    @EnclosingPath
    private var location

    var body: some DirectoryContent {
        File("MANIFEST.txt") {
            "Contents of \(location ?? "")"
            "- README.md"
        }
        File("README.md", text: "# \(name)")
    }

}
// Manifest(name: "Docs") written at the top level produces Docs/MANIFEST.txt containing:
// Contents of Docs
// - README.md
// snippet.end

// snippet.hide
let destination = FileManager.default.temporaryDirectory
try await sources.write(to: destination, shouldOverwrite: true)
try await Manifest(name: "Docs").write(to: destination, shouldOverwrite: true)
print("Wrote to \(destination.path(percentEncoded: false))")
