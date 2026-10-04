// Read the name of the file being rendered with `@FileName`.

// snippet.hide
import Calligraphy
import Foundation

// snippet.show
// snippet.header
struct FileHeader: StringComponent {

    @FileName
    private var fileName

    var body: some StringComponent {
        "// " + (fileName ?? "Untitled")
        "//"
    }

}

let sources = Folder("Sources") {
    File("User.swift") {
        FileHeader()
        "struct User {}"
    }
}
// User.swift contains:
// // User.swift
// //
// struct User {}
// snippet.end

// snippet.hide
let destination = FileManager.default.temporaryDirectory
try await sources.write(to: destination, shouldOverwrite: true)
print("Wrote Sources to \(destination.path(percentEncoded: false))")
