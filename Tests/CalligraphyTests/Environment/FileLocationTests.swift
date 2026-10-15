// Calligraphy
// FileLocationTests.swift
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

@Suite("File Location Tests", .tags(.environment, .directoryComposition))
struct FileLocationTests {

    private struct Report: StringComponent {

        @FilePath
        private var relativePath

        @FilePath(.absolute)
        private var absolutePath

        @FileURL
        private var url

        @EnclosingPath
        private var relativeFolder

        @EnclosingPath(.absolute)
        private var absoluteFolder

        @EnclosingURL
        private var folderURL

        var body: some StringComponent {
            Lines {
                "path=" + (relativePath ?? "nil")
                "abs=" + (absolutePath ?? "nil")
                "url=" + (url?.absoluteString ?? "nil")
                "folder=" + (relativeFolder ?? "nil")
                "absfolder=" + (absoluteFolder ?? "nil")
                "folderurl=" + (folderURL?.absoluteString ?? "nil")
            }
        }

    }

    private struct SelfLocating: Directory {

        let name: String

        @EnclosingPath
        private var ownLocation

        var body: some DirectoryContent {
            File("where.txt") {
                "own=" + (ownLocation ?? "nil")
            }
        }

    }

    private func text(in content: [SerializedDirectoryContent], at path: [String]) -> String? {
        var entries = content
        for component in path.dropLast() {
            guard let next = entries.first(where: { $0.name == component }),
                  case let .directory(children) = next.content else {
                return nil
            }
            entries = children
        }
        guard let entry = entries.first(where: { $0.name == path.last }),
              case let .file(.text(text, _)) = entry.content else {
            return nil
        }
        return text
    }

    private func lines(_ text: String?) -> [String: String] {
        var result: [String: String] = [:]
        for line in text?.split(separator: "\n") ?? [] {
            let parts = line.split(separator: "=", maxSplits: 1)
            result[String(parts[0])] = parts.count > 1 ? String(parts[1]) : ""
        }
        return result
    }

    @Test("Relative locations are available without a destination")
    func relative() {
        let content = Folder("Sources") {
            Folder("Models") {
                File("User.swift") {
                    Report()
                }
            }
        }
        let values = lines(text(in: content._serialize(), at: ["Sources", "Models", "User.swift"]))
        #expect(values["path"] == "Sources/Models/User.swift")
        #expect(values["folder"] == "Sources/Models")
        #expect(values["abs"] == "nil")
        #expect(values["url"] == "nil")
        #expect(values["absfolder"] == "nil")
        #expect(values["folderurl"] == "nil")
    }

    @Test("Top-level files have an empty enclosing path")
    func topLevel() {
        let content = File("README.md") {
            Report()
        }
        let values = lines(text(in: content._serialize(), at: ["README.md"]))
        #expect(values["path"] == "README.md")
        #expect(values["folder"] == "")
    }

    @Test("Outside of a file only the enclosing path resolves")
    func outsideFile() {
        let values = lines(String(Report()))
        #expect(values["path"] == "nil")
        #expect(values["url"] == "nil")
        #expect(values["folder"] == "")
    }

    @Test("A directory's own properties see its parent")
    func directoryProperties() {
        let content = Folder("Root") {
            SelfLocating(name: "Child")
        }
        #expect(text(in: content._serialize(), at: ["Root", "Child", "where.txt"]) == "own=Root")
        #expect(text(in: SelfLocating(name: "Top")._serialize(), at: ["Top", "where.txt"]) == "own=")
    }

    @Test("Writing to disk resolves absolute locations")
    func absolute() async throws {
        let destination = FileManager.default.temporaryDirectory
            .appending(path: "calligraphy location \(UUID().uuidString)", directoryHint: .isDirectory)
        try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: destination) }

        let content = Folder("Sources") {
            File("User.swift") {
                Report()
            }
        }
        try await content.write(to: destination)

        let written = destination
            .appending(path: "Sources", directoryHint: .isDirectory)
            .appending(path: "User.swift", directoryHint: .notDirectory)
        let values = try lines(String(contentsOf: written, encoding: .utf8))
        let root = String(destination.standardizedFileURL.path(percentEncoded: false).dropLast())
        #expect(values["path"] == "Sources/User.swift")
        #expect(values["abs"] == root + "/Sources/User.swift")
        #expect(values["url"] == written.standardizedFileURL.absoluteString)
        #expect(values["folder"] == "Sources")
        #expect(values["absfolder"] == root + "/Sources")
        #expect(values["folderurl"] == destination.standardizedFileURL.appending(path: "Sources", directoryHint: .isDirectory).absoluteString)
    }

    @Test("Top-level absolute enclosing path is the destination itself")
    func absoluteTopLevel() async throws {
        let destination = FileManager.default.temporaryDirectory
            .appending(path: "calligraphy root \(UUID().uuidString)", directoryHint: .isDirectory)
        try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: destination) }

        try await File("README.md") { Report() }.write(to: destination)

        let values = try lines(String(contentsOf: destination.appending(path: "README.md"), encoding: .utf8))
        let root = String(destination.standardizedFileURL.path(percentEncoded: false).dropLast())
        #expect(values["absfolder"] == root)
        #expect(values["folderurl"] == destination.standardizedFileURL.absoluteString)
        #expect(values["abs"] == root + "/README.md")
    }

}
