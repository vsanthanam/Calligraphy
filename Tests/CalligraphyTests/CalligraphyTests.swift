// Calligraphy
// CalligraphyTests.swift
//
// MIT License
//
// Copyright (c) 2025 Varun Santhanam
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

@testable import Calligraphy
import Foundation
import Testing

@Test
func example() async throws {

    let test = String(
        calligraphy: {
            "foo"
            Line {
                Tab()
                "bar"
            }
            "baz"
            Line {
                "foo"
                "bar"
                Space()
                "baz"
            }
            Tabbed {
                Lines(spacing: 2) {
                    for i in 0 ..< 4 {
                        "\(i)"
                    }
                }
            }
            Strokes {
                "foo"
                "bar"
                "baz"
                "qux"
            }
            .joined(separator: ", ")
            .tabbed(3)
        }
    )

    let expected = """
    foo
        bar
    baz
    foobar baz
        0
        
        1
        
        2
        
        3
                foo, bar, baz, qux
    """
    #expect(test == expected)

    let folder = Folder("foo") {
        File("README", extension: "md") {
            "sup"
        }
        Folder("bar") {
            File("tweet", content: expected)
        }
    }

    let temp = FileManager.default.temporaryDirectory
    try await folder.write(toDirectory: temp, shouldOverwrite: true)
    let rootDir = temp.appending(path: "foo", directoryHint: .isDirectory)
    guard FileManager.default.fileExists(atPath: rootDir.path()) else {
        Issue.record("oh no")
        return
    }
    let readmePath = rootDir.appending(path: "README.md", directoryHint: .notDirectory)
    let readmeFile = try String(contentsOf: readmePath, encoding: .utf8)
    #expect(readmeFile == "sup")
    let barUrl = rootDir.appending(path: "bar", directoryHint: .isDirectory)
    guard FileManager.default.fileExists(atPath: barUrl.path()) else {
        Issue.record("well shit")
        return
    }
    let tweetUrl = barUrl.appending(path: "tweet", directoryHint: .notDirectory)
    let tweetFile = try String(contentsOf: tweetUrl, encoding: .utf8)
    #expect(tweetFile == expected)
}

@Test
func zipped() {
    let str = String(calligraphy: basicQuote)
    #expect(str == #"""
    'foo-"barbaz"-qux'
    """#)
}

@Calligraphy
func basicQuote() -> some Stroke {
    Quote(.single) {
        Strokes {
            "foo"
            Quote {
                Line {
                    "bar"
                    "baz"
                }
            }
            "qux"
        }
    }
    .joined(separator: "-")
}
