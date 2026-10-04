// Package a reusable transformation of files and folders as a
// `DirectoryContentModifier`, then expose it as a method on `DirectoryContent`
// so it reads like a built-in modifier.

// snippet.hide
import Calligraphy
import Foundation

// snippet.show
// snippet.modifier
struct Licensed: DirectoryContentModifier {

    func body(content: Content) -> some DirectoryContent {
        content
        File("LICENSE") {
            "MIT License"
        }
    }

}
// snippet.end

// snippet.extension
extension DirectoryContent {

    func licensed() -> some DirectoryContent {
        modifier(Licensed())
    }

}
// snippet.end

// snippet.hide
let project = Folder("MyProject") {
    File("README.md") {
        "# My Project"
    }
    .licensed()
}

let destination = FileManager.default.temporaryDirectory
try await project.write(to: destination, shouldOverwrite: true)
print("Wrote MyProject with a LICENSE to \(destination.path(percentEncoded: false))")
