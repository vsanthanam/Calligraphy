// Calligraphy
// DynamicPropertyTests.swift
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

extension EnvironmentValues {

    @Entry
    fileprivate var dynamicPropertyTestPrefix: String = ""

    @Entry
    fileprivate var dynamicPropertyTestSuffix: String = ""

}

@Suite("DynamicProperty Tests", .tags(.environment))
struct DynamicPropertyTests {

    /// A wrapper that combines two environment values, relying entirely on the default injection.
    @propertyWrapper
    private struct Decorated: DynamicProperty {

        @Environment(\.dynamicPropertyTestPrefix)
        private var prefix

        @Environment(\.dynamicPropertyTestSuffix)
        private var suffix

        let text: String

        init(wrappedValue: String) {
            text = wrappedValue
        }

        var wrappedValue: String {
            prefix + text + suffix
        }

    }

    /// A wrapper that nests another dynamic property, including a built-in one.
    @propertyWrapper
    private struct DecoratedFileName: DynamicProperty {

        @Decorated
        private var placeholder = "?"

        @FileName
        private var fileName

        var wrappedValue: String {
            fileName ?? placeholder
        }

    }

    /// A wrapper that overrides injection by hand.
    @propertyWrapper
    private struct Manual: DynamicProperty {

        private final class Box {
            var value = "uninjected"
        }

        private let box = Box()

        var wrappedValue: String {
            box.value
        }

        func _inject(_ values: EnvironmentValues) {
            box.value = values.dynamicPropertyTestPrefix + "manual"
        }

    }

    /// A plain struct holding an environment property, which is not a dynamic property.
    private struct Plain {

        @Environment(\.dynamicPropertyTestPrefix)
        var prefix

    }

    private struct DecoratedText: StringComponent {

        @Decorated
        private var text = "text"

        var body: some StringComponent {
            text
        }

    }

    @Test("Default injection resolves nested environment properties")
    func defaultInjection() {
        let component = DecoratedText()
            .environment(\.dynamicPropertyTestPrefix, "<")
            .environment(\.dynamicPropertyTestSuffix, ">")
        #expect(String(component) == "<text>")
    }

    @Test("Unset values fall back to their defaults")
    func defaults() {
        #expect(String(DecoratedText()) == "text")
    }

    @Test("Dynamic properties nest, including built-in ones")
    func nested() {
        struct Header: StringComponent {

            @DecoratedFileName
            private var name

            var body: some StringComponent {
                name
            }

        }
        let file = File("notes.txt") {
            Header()
        }
        .environment(\.dynamicPropertyTestPrefix, "[")
        .environment(\.dynamicPropertyTestSuffix, "]")
        let entries = file._serialize()
        guard case let .file(.text(text, _)) = entries.first?.content else {
            Issue.record("Expected a text file")
            return
        }
        #expect(text == "notes.txt")
        #expect(String(Header().environment(\.dynamicPropertyTestPrefix, "[").environment(\.dynamicPropertyTestSuffix, "]")) == "[?]")
    }

    @Test("Custom injection is honored")
    func manualInjection() {
        struct Component: StringComponent {

            @Manual
            private var value

            var body: some StringComponent {
                value
            }

        }
        let component = Component()
            .environment(\.dynamicPropertyTestPrefix, "very ")
        #expect(String(component) == "very manual")
    }

    @Test("Dynamic properties work in modifiers")
    func modifiers() {
        struct Wrap: StringModifier {

            @Decorated
            private var text = "wrapped"

            func body(
                content: Content
            ) -> some StringComponent {
                text
            }

        }
        let component = RawStringComponent("ignored")
            .modifier(Wrap())
            .environment(\.dynamicPropertyTestPrefix, "(")
            .environment(\.dynamicPropertyTestSuffix, ")")
        #expect(String(component) == "(wrapped)")
    }

    @Test("Dynamic properties work in data components")
    func data() {
        struct Bytes: DataComponent {

            @Decorated
            private var text = "data"

            var body: some DataComponent {
                Data(text.utf8)
            }

        }
        let component = Bytes()
            .environment(\.dynamicPropertyTestPrefix, "<")
            .environment(\.dynamicPropertyTestSuffix, ">")
        #expect(Data(component) == Data("<data>".utf8))
    }

    @Test("Properties stored in non-dynamic types are not injected")
    func plainStorage() {
        struct Component: StringComponent {

            let plain = Plain()

            var body: some StringComponent {
                plain.prefix + "text"
            }

        }
        let component = Component()
            .environment(\.dynamicPropertyTestPrefix, "<")
        #expect(String(component) == "text")
    }

}
