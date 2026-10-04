// Calligraphy
// FileNameTests.swift
//
// MIT License
//
// Copyright (c) 2026 Varun Santhanam
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the  Software), to deal
//
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Calligraphy
import Foundation
import Testing

@Suite("@FileName Tests", .tags(.environment, .directoryComposition, .dataComposition))
struct FileNameTests {

    private struct Header: StringComponent {

        @FileName
        private var fileName

        var body: some StringComponent {
            "// " + (fileName ?? "nil")
        }

    }

    private struct NameBytes: DataComponent {

        @FileName
        private var fileName

        var body: some DataComponent {
            Data((fileName ?? "nil").utf8)
        }

    }

    private struct ReadmeFile: TextFile {

        let name = "README.md"

        var body: some StringComponent {
            Header()
        }

    }

    private struct BlobFile: DataFile {

        let name = "blob.bin"

        var body: some DataComponent {
            NameBytes()
        }

    }

    private struct SelfReadingFile: TextFile {

        let name = "self.txt"

        @FileName
        private var ownName

        var body: some StringComponent {
            "own=" + (ownName ?? "nil")
        }

    }

    private func text(of content: some DirectoryContent, named name: String) -> String? {
        for entry in content._serialize() where entry.name == name {
            switch entry.content {
            case let .file(.text(text, _)):
                return text
            case let .file(.data(data)):
                return String(decoding: data, as: UTF8.self)
            case .directory:
                return nil
            }
        }
        return nil
    }

    @Test("String component inside File reads the file name")
    func fileText() {
        let content = File("User", fileExtension: "swift") {
            Header()
        }
        #expect(text(of: content, named: "User.swift") == "// User.swift")
    }

    @Test("Data component inside File reads the file name")
    func fileData() {
        let content = File("blob.bin") {
            NameBytes()
        }
        #expect(text(of: content, named: "blob.bin") == "blob.bin")
    }

    @Test("TextFile and DataFile conformers pass their name to their body")
    func conformers() {
        #expect(text(of: ReadmeFile(), named: "README.md") == "// README.md")
        #expect(text(of: BlobFile(), named: "blob.bin") == "blob.bin")
    }

    @Test("Nested folders do not interfere")
    func nested() {
        let content = Folder("A") {
            Folder("B") {
                File("c.txt") {
                    Header()
                }
            }
        }
        let serialized = content._serialize()
        guard case let .directory(a) = serialized[0].content,
              case let .directory(b) = a[0].content,
              case let .file(.text(text, _)) = b[0].content else {
            Issue.record("unexpected structure")
            return
        }
        #expect(text == "// c.txt")
    }

    @Test("nil outside of any file")
    func outsideFile() {
        #expect(String(Header()) == "// nil")
        #expect(Data(NameBytes()) == Data("nil".utf8))
    }

    @Test("A file's own wrapper sees the enclosing environment, not its own name")
    func ownWrapper() {
        #expect(text(of: SelfReadingFile(), named: "self.txt") == "own=nil")
    }

    @Test("Written file contains its own name")
    func written() async throws {
        let root = FileManager.default.temporaryDirectory
            .appending(path: "calligraphy-filename-\(UUID().uuidString)", directoryHint: .isDirectory)
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: root) }
        try await File("Header.swift") { Header() }.write(to: root)
        let written = try String(contentsOf: root.appending(path: "Header.swift", directoryHint: .notDirectory), encoding: .utf8)
        #expect(written == "// Header.swift")
    }

}
