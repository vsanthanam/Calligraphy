// Repeat files and folders for every element in a collection with `ForEach`.

// snippet.hide
import Calligraphy
import Foundation

let models = ["User", "Account", "Session"]

// snippet.show
// snippet.files
let sources = Folder("Models") {
    ForEach(models) { model in
        File(model, fileExtension: "swift") {
            "struct \(model) {}"
        }
    }
}
// snippet.end

// snippet.hide
let destination = FileManager.default.temporaryDirectory
try await sources.write(to: destination, shouldOverwrite: true)
print("Wrote Models to \(destination.path(percentEncoded: false))")
