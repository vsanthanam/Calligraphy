// Calligraphy
// LineSpacingTests.swift
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
import Testing

@Suite("Line Spacing Tests", .tags(.stringComposition))
struct LineSpacingTests {

    @Test("Modifier")
    func modifier() {
        let str = String.build {
            Lines {
                Lines {
                    "foo"
                    "bar"
                }
                .lineSpacing(1)
                Lines {
                    "baz"
                    "qux"
                }
                .lineSpacing(1)
                Lines {
                    "quux"
                    "corge"
                }
                .lineSpacing(1)
            }
            .lineSpacing(2)
        }

        #expect(str == """
        foo
        bar

        baz
        qux

        quux
        corge
        """)
    }

    @Test("Nested Lines Inherit the Spacing")
    func nestedLinesInherit() {
        let component = Lines {
            "foo"
            Lines {
                "bar"
                "baz"
            }
        }
        .lineSpacing(2)
        #expect(String(component) == """
        foo

        bar

        baz
        """)
    }

    @Test("Nested Lines Can Override the Spacing")
    func nestedLinesOverride() {
        let component = Lines {
            "foo"
            Lines {
                "bar"
                "baz"
            }
            .lineSpacing(1)
        }
        .lineSpacing(2)
        #expect(String(component) == """
        foo

        bar
        baz
        """)
    }

    @Test("Spacing Passes Through Transparent Components")
    func passesThroughGroups() {
        let direct = StringGroup {
            Lines {
                "foo"
                "bar"
            }
        }
        .lineSpacing(2)
        #expect(String(direct) == """
        foo

        bar
        """)

        let nested = Lines {
            "foo"
            StringGroup {
                Lines {
                    "bar"
                    "baz"
                }
            }
        }
        .lineSpacing(2)
        #expect(String(nested) == """
        foo

        bar

        baz
        """)
    }

}
