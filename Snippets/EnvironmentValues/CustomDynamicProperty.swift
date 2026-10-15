// Define a property wrapper that derives its value from the environment with `DynamicProperty`.

// snippet.hide
import Calligraphy
import Foundation

// snippet.show
// snippet.wrapper
@propertyWrapper
struct FileExtension: DynamicProperty {

    @FileName
    private var fileName

    var wrappedValue: String? {
        guard let fileName, let dot = fileName.lastIndex(of: ".") else {
            return nil
        }
        return String(fileName[fileName.index(after: dot)...])
    }

}
// snippet.end

// snippet.usage
struct LicenseHeader: StringComponent {

    @FileExtension
    private var fileExtension

    var body: some StringComponent {
        let marker = fileExtension == "sh" ? "#" : "//"
        marker + " Copyright (c) 2026"
    }

}

let sources = Folder("Sources") {
    File("main.swift") {
        LicenseHeader()
    }
    File("build.sh") {
        LicenseHeader()
    }
}
// main.swift begins with `// Copyright (c) 2026`
// build.sh begins with `# Copyright (c) 2026`
// snippet.end

// snippet.hide
let destination = FileManager.default.temporaryDirectory
try await sources.write(to: destination, shouldOverwrite: true)
print("Wrote Sources to \(destination.path(percentEncoded: false))")
