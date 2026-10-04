// Define reusable file and folder types with `TextFile`, `DataFile`, and `Directory`,
// combine them with the Calligraphy builders, and write the result to disk.

// snippet.hide
import Calligraphy
import Foundation

// snippet.show
// snippet.text-file
struct ReadmeFile: TextFile {

    let name = "README.md"

    var body: some StringComponent {
        "# My Project"
    }

}
// snippet.end

// snippet.data-file
struct ConfigFile: DataFile {

    let name = "config.bin"

    var body: some DataComponent {
        0x01 // Version
        0x02 // Flags
        0x03 // Data
    }

}
// snippet.end

// snippet.directory
struct MyProject: Directory {

    let name = "MyProject"

    var body: some DirectoryContent {
        ReadmeFile()
        ConfigFile()
    }

}
// snippet.end

// snippet.combining-builders
struct Documentation: Directory {

    let name = "Documentation"

    var body: some DirectoryContent {
        File("README.md") {
            "# Documentation"
            ""
            "This is the documentation for our project."
        }
        Folder("API") {
            File("API.md") {
                "# API Reference"
                ""
                "Detailed API documentation..."
            }
        }
    }

}
// snippet.end

// snippet.writing-to-disk
let project = Files {
    Folder("Project") {
        Documentation()
        MyProject()
    }
    File("License", fileExtension: "txt") {
        "License Here"
    }
}

let destination = FileManager.default.temporaryDirectory
try await project.write(to: destination, shouldOverwrite: true)
// snippet.end

// snippet.hide
print("Wrote Project to \(destination.path(percentEncoded: false))")
