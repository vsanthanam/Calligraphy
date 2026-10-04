// Calligraphy
// ModifiedStringTests.swift
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

@Suite("ModifiedString Tests", .tags(.stringComposition))
struct ModifiedStringTests {

    @Test("Modifier body composes around the content")
    func composes() {
        let component = Lines {
            "foo"
            "bar"
        }
        .modifier(Commented())

        #expect(String(component) == """
        // foo
        // bar
        """)
    }

    @Test("Initializer matches the modifier method")
    func initializer() {
        let content = Lines {
            "foo"
            "bar"
        }
        let component = ModifiedString(
            content: content,
            modifier: Commented()
        )

        #expect(String(component) == String(content.modifier(Commented())))
    }

    @Test("Modifiers chain innermost first")
    func chaining() {
        let component = Lines {
            "foo"
            "bar"
        }
        .modifier(Commented())
        .modifier(Commented(prefix: "# "))

        #expect(String(component) == """
        # // foo
        # // bar
        """)
    }

    @Test("Modifiers read the surrounding environment")
    func readsEnvironment() {
        let component = Lines {
            "foo"
            "bar"
        }
        .modifier(LineSpacingReport())
        .lineSpacing(3)

        #expect(String(component) == """
        foo
        bar
        spacing: 3
        """)
    }

    @Test("Environment set in the modifier body reaches the content")
    func environmentFlowsToContent() {
        let component = Lines {
            "foo"
            "bar"
        }
        .tabbed()
        .modifier(FourSpaceTabs())

        #expect(String(component) == """
            foo
            bar
        """)
    }

    @Test("Modifier body can skip the content")
    func skipsContent() {
        let component = Lines {
            "foo"
            Lines {
                "bar"
            }
            .modifier(Hidden())
            "baz"
        }

        #expect(String(component) == """
        foo
        baz
        """)
    }

    @Test("Primitive modifier renders directly")
    func primitive() {
        let component = Lines {
            "foo"
            "bar"
        }
        .modifier(Uppercased())

        #expect(String(component) == """
        FOO
        BAR
        """)
    }

    @Test("Primitive modifier reads the surrounding environment")
    func primitiveReadsEnvironment() {
        let component = Lines {
            "foo"
            "bar"
        }
        .modifier(SpacingSuffix())
        .lineSpacing(3)

        #expect(String(component) == """
        foo


        bar (spacing 3)
        """)
    }

    @Test("Convenience extension returning an opaque type")
    func convenience() {
        let component = Lines {
            "foo"
            "bar"
        }
        .commented()

        #expect(String(component) == """
        // foo
        // bar
        """)
    }

}

private struct Commented: StringModifier {

    var prefix = "// "

    func body(
        content: Content
    ) -> some StringComponent {
        content
            .prefixLines(with: prefix)
    }

}

private struct LineSpacingReport: StringModifier {

    @Environment(\.lineSpacing)
    private var lineSpacing

    func body(
        content: Content
    ) -> some StringComponent {
        Lines {
            content
            "spacing: \(lineSpacing)"
        }
        .lineSpacing(1)
    }

}

private struct FourSpaceTabs: StringModifier {

    func body(
        content: Content
    ) -> some StringComponent {
        content
            .tabDefinition(.spaces(4))
    }

}

private struct Hidden: StringModifier {

    func body(
        content: Content
    ) -> some StringComponent {
        if false {
            content
        }
    }

}

private struct Uppercased: StringModifier {

    func body(
        content: Content
    ) -> Never {
        fatalError()
    }

    func render(
        content: Content,
        in environment: EnvironmentValues
    ) -> String? {
        content.render(in: environment)?.uppercased()
    }

}

private struct SpacingSuffix: StringModifier {

    @Environment(\.lineSpacing)
    private var lineSpacing

    func body(
        content: Content
    ) -> Never {
        fatalError()
    }

    func render(
        content: Content,
        in environment: EnvironmentValues
    ) -> String? {
        (content.render(in: environment) ?? "") + " (spacing \(lineSpacing))"
    }

}

extension StringComponent {

    fileprivate func commented() -> some StringComponent {
        modifier(Commented())
    }

}
