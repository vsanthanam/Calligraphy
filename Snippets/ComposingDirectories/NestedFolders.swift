// Build nested directory structures with the `Folder` type.

// snippet.hide
import Calligraphy
import Foundation

// snippet.show
// snippet.folders
let project = Folder("MyProject") {
    File("README.md") {
        "# My Project"
    }
    Folder("Sources") {
        File("main.swift") {
            Line {
                "print("
                Quote {
                    "Hello, World!"
                }
                ")"
            }
        }
    }
}
// snippet.end

// snippet.hide
let destination = FileManager.default.temporaryDirectory
try await project.write(to: destination, shouldOverwrite: true)
print("Wrote MyProject to \(destination.path(percentEncoded: false))")
