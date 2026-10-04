// Set environment values on a folder so they reach every file inside it.

// snippet.hide
import Calligraphy
import Foundation

// snippet.show
// snippet.folder-environment
let generated = Folder("Generated") {
    File("A.swift") {
        Lines {
            "import Foundation"
            "struct A {}"
        }
    }
    File("B.swift") {
        Lines {
            "import Foundation"
            "struct B {}"
        }
    }
}
.lineSpacing(2)
// Every file in the folder renders with two newlines between lines.
// snippet.end

// snippet.hide
let destination = FileManager.default.temporaryDirectory
try await generated.write(to: destination, shouldOverwrite: true)
print("Wrote to \(destination.path(percentEncoded: false))")
