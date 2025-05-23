// Calligraphy
// MapLinesTests.swift
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

import Calligraphy
import Testing

@Suite("Map Lines Tests", .tags(.stringComposition))
struct MapLinesTests {

    @Test("Modifier with String")
    func stringModifier() {
        let mapLines = Lines {
            "foo"
            "bar"
            "baz"
        }
        .mapLines { line in
            "- " + line.uppercased()
        }

        let expected = #"""
        - FOO
        - BAR
        - BAZ
        """#

        #expect(mapLines._content == expected)
    }

    @Test("Modifier with Builder")
    func builderModifier() {
        let mapLines = Lines {
            "foo"
            "bar"
            "baz"
        }
        .mapLines { line in
            Line {
                "-"
                Space()
                line
            }
        }

        let expected = #"""
        - foo
        - bar
        - baz
        """#

        #expect(mapLines._content == expected)
    }

    @Test("Empty Lines")
    func mapLinesEmpty() {
        let mapLines = Lines {}
            .mapLines { line in
                "testing" + line
            }
        #expect(mapLines._content == nil)
    }

    @Test("Not Empty Rule")
    func builderModifierWithNotEmptyRule() {
        let mapLines = Lines(spacing: 2) {
            "foo"
            "bar"
            "baz"
        }
        .mapLines(.notEmpty) { line in
            "- " + line
        }

        let expected = #"""
        - foo

        - bar

        - baz
        """#

        #expect(mapLines._content == expected)
    }

    @Test("Empty Rule")
    func builderModifierWithEmptyRule() {
        let mapLines = Lines(spacing: 2) {
            "foo"
            "bar"
            "baz"
        }
        .mapLines(.empty) { line in
            Line {
                "----"
                line
                "|"
                "----"
            }
        }

        let expected = #"""
        foo
        ----|----
        bar
        ----|----
        baz
        """#

        #expect(mapLines._content == expected)
    }
}
