// Calligraphy
// TabbedTests.swift
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

@Suite("Tabbed Tests", .tags(.stringComposition))
struct TabbedTests {

    @available(*, deprecated)
    @Test("Modifier with default count")
    func standard() {
        let tabbed = StringGroup {
            "foo"
            "bar"
            "baz"
        }
        .tabbed()

        let expected = #"""
          foo
          bar
          baz
        """#

        #expect(String(tabbed) == expected)
    }

    @Test("Modifier with explicit count")
    func modifier() {
        let tabbed = Lines {
            "foo"
            "bar"
            "baz"
        }
        .tabbed(2)

        let expected = #"""
            foo
            bar
            baz
        """#

        #expect(String(tabbed) == expected)
    }

    @available(*, deprecated)
    @Test("Blank lines are not indented")
    func blankLines() {
        let tabbed = StringGroup {
            "foo"
            Blank()
            "bar"
        }
        .tabbed()

        #expect(String(tabbed) == "  foo\n\n  bar")
    }

    @available(*, deprecated)
    @Test("Nested inside a line prefix")
    func nestedInsidePrefix() {
        let component = Lines {
            "foo"
            StringGroup {
                "bar"
                Blank()
                "baz"
            }
            .tabbed()
        }
        .prefixLines(with: "// ")

        #expect(String(component) == "// foo\n//   bar\n// \n//   baz")
    }

    @available(*, deprecated)
    @Test("Line prefix nested inside")
    func prefixNestedInside() {
        let component = Lines {
            "foo"
            Blank()
            "bar"
        }
        .prefixLines(with: "// ")
        .tabbed()

        #expect(String(component) == "  // foo\n  // \n  // bar")
    }

    @Test("Deprecated: Tabbed component")
    @available(*, deprecated)
    func deprecatedComponent() {
        let tabbed = Tabbed {
            "foo"
            Blank()
            "bar"
        }
        #expect(String(tabbed) == "  foo\n\n  bar")
    }

    @Test("Deprecated: Modifier with explicit tab definition")
    @available(*, deprecated)
    func deprecatedModifierWithDefinition() {
        let tabbed = Lines {
            "foo"
            "bar"
        }
        .tabbed(1, .spaces(4))
        #expect(String(tabbed) == "    foo\n    bar")
    }

}
