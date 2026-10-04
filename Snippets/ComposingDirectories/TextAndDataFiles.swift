// Create text and data files with the `File` type.

// snippet.hide
import Calligraphy
import Foundation

// snippet.show
// snippet.files
// Create a text file
let textFile = File("README.md") {
    "# My Project"
    ""
    "This is a sample project."
}

// Create a data file
let dataFile = File("config.json") {
    Data("{\"key\": \"value\"}".utf8)
}
// snippet.end

// snippet.hide
let destination = FileManager.default.temporaryDirectory
try await Files {
    textFile
    dataFile
}
.write(to: destination, shouldOverwrite: true)
print("Wrote files to \(destination.path(percentEncoded: false))")
