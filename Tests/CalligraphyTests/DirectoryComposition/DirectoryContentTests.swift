// Calligraphy
// DirectoryContentTests.swift
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

@Suite("Directory Content Tests", .tags(.directoryComposition))
struct DirectoryContentTests {

    @Test("Basic write")
    func basicWrite() async throws {
        let content = Files {
            File("foo.txt") {
                "bar"
                "baz"
            }
            Folder("bar") {
                File("baz.txt") {
                    "qux"
                    "quux"
                }
                File("quuz.txt") {
                    "corge"
                    "grault"
                }
            }
        }
        let directory = FileManager.default.temporaryDirectory
        try await content.write(to: directory, shouldOverwrite: true)
        let fooURL = directory.appending(path: "foo.txt", directoryHint: .notDirectory)
        let fooData = try Data(contentsOf: fooURL)
        let fooString = try #require(String(data: fooData, encoding: .utf8))
        #expect(fooString == "bar\nbaz")
        let barURL = directory.appending(path: "bar", directoryHint: .isDirectory)
        #expect(FileManager.default.fileExists(atPath: barURL.path()))
        let bazURL = barURL.appending(path: "baz.txt", directoryHint: .notDirectory)
        let bazData = try Data(contentsOf: bazURL)
        let bazString = try #require(String(data: bazData, encoding: .utf8))
        #expect(bazString == "qux\nquux")
        let quuzURL = barURL.appending(path: "quuz.txt", directoryHint: .notDirectory)
        let quuzData = try Data(contentsOf: quuzURL)
        let quuzString = try #require(String(data: quuzData, encoding: .utf8))
        #expect(quuzString == "corge\ngrault")
    }

    @Test("Sibling names that differ only by case are rejected")
    func caseInsensitiveDuplicateNames() async throws {
        let directory = try makeTemporaryDirectory()
        defer { try? FileManager.default.removeItem(at: directory) }
        let content = Folder("out") {
            File("README.md", text: "upper")
            File("readme.md", text: "lower")
        }
        await #expect(throws: (any Error).self) {
            try await content.write(to: directory)
        }
        let outURL = directory.appending(path: "out", directoryHint: .isDirectory)
        #expect(!FileManager.default.fileExists(atPath: outURL.path()))
    }

    @Test("Empty names are rejected")
    func emptyName() async throws {
        let directory = try makeTemporaryDirectory()
        defer { try? FileManager.default.removeItem(at: directory) }
        let content = Folder("out") {
            File("", text: "nameless")
        }
        await #expect(throws: (any Error).self) {
            try await content.write(to: directory)
        }
        #expect(!FileManager.default.fileExists(atPath: directory.appending(path: "out").path()))
    }

    @Test("Names containing illegal characters are rejected", arguments: ["a/b", "a\\b", "a:b", "a?b", "a*b", "a\"b", "a<b", "a>b", "a|b"])
    func illegalCharacters(name: String) async throws {
        let directory = try makeTemporaryDirectory()
        defer { try? FileManager.default.removeItem(at: directory) }
        let content = Folder("out") {
            File(name, text: "illegal")
        }
        await #expect(throws: (any Error).self) {
            try await content.write(to: directory)
        }
        #expect(!FileManager.default.fileExists(atPath: directory.appending(path: "out").path()))
    }

    @Test("Validation applies to nested folders")
    func nestedValidation() async throws {
        let directory = try makeTemporaryDirectory()
        defer { try? FileManager.default.removeItem(at: directory) }
        let content = Folder("out") {
            File("ok.txt", text: "fine")
            Folder("nested") {
                File("dup.txt", text: "one")
                File("DUP.txt", text: "two")
            }
        }
        await #expect(throws: (any Error).self) {
            try await content.write(to: directory)
        }
        #expect(!FileManager.default.fileExists(atPath: directory.appending(path: "out").path()))
    }

    #if os(Windows)
        @Test("Windows reserved device names are rejected", arguments: ["CON", "con", "con.txt", "CON.tar.gz", "NUL", "COM1", "lpt9", "AUX.swift", "nul.ls.txt.bak"])
        func windowsReservedNames(name: String) async throws {
            let directory = try makeTemporaryDirectory()
            defer { try? FileManager.default.removeItem(at: directory) }
            let content = Folder("out") {
                File(name, text: "reserved")
            }
            await #expect(throws: (any Error).self) {
                try await content.write(to: directory)
            }
            #expect(!FileManager.default.fileExists(atPath: directory.appending(path: "out").path()))
        }

        @Test("Windows names that merely contain a reserved word are allowed", arguments: ["CONSOLE", "console.txt", "mycon", "COM10", "LPT0", "nullable.txt"])
        func windowsNonReservedNames(name: String) async throws {
            let directory = try makeTemporaryDirectory()
            defer { try? FileManager.default.removeItem(at: directory) }
            let content = Folder("out") {
                File(name, text: "fine")
            }
            try await content.write(to: directory)
            #expect(FileManager.default.fileExists(atPath: directory.appending(path: "out").appending(path: name).path()))
        }

        @Test("Windows names ending in a period or space are rejected", arguments: ["trailing.", "trailing ", "folder. "])
        func windowsTrailingPeriodOrSpace(name: String) async throws {
            let directory = try makeTemporaryDirectory()
            defer { try? FileManager.default.removeItem(at: directory) }
            let content = Folder("out") {
                File(name, text: "trailing")
            }
            await #expect(throws: (any Error).self) {
                try await content.write(to: directory)
            }
            #expect(!FileManager.default.fileExists(atPath: directory.appending(path: "out").path()))
        }

        @Test("Windows names containing control characters are rejected")
        func windowsControlCharacters() async throws {
            let directory = try makeTemporaryDirectory()
            defer { try? FileManager.default.removeItem(at: directory) }
            let content = Folder("out") {
                File("a\u{01}b.txt", text: "control")
            }
            await #expect(throws: (any Error).self) {
                try await content.write(to: directory)
            }
            #expect(!FileManager.default.fileExists(atPath: directory.appending(path: "out").path()))
        }
    #endif

    #if !os(Windows)
        @Test("Permissions are applied to written files and directories")
        func permissionsApplied() async throws {
            let directory = try makeTemporaryDirectory()
            defer { try? FileManager.default.removeItem(at: directory) }
            let content = Folder("out", permissions: [.readUser, .writeUser, .executeUser]) {
                File("script.sh", permissions: .executableFile, text: "#!/bin/sh")
            }
            try await content.write(to: directory)
            let outURL = directory.appending(path: "out", directoryHint: .isDirectory)
            let scriptURL = outURL.appending(path: "script.sh", directoryHint: .notDirectory)
            let outMode = try #require(FileManager.default.attributesOfItem(atPath: outURL.path())[.posixPermissions] as? Int)
            let scriptMode = try #require(FileManager.default.attributesOfItem(atPath: scriptURL.path())[.posixPermissions] as? Int)
            #expect(outMode == 0o700)
            #expect(scriptMode == 0o755)
        }
    #endif

    private func makeTemporaryDirectory() throws -> URL {
        let url = FileManager.default.temporaryDirectory.appending(path: "calligraphy-\(UUID().uuidString)", directoryHint: .isDirectory)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }

}
