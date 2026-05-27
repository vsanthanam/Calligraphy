// Calligraphy
// StringDynamicPropertyTests.swift
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

@testable import Calligraphy
import Testing

@Suite("String Dynamic Property Tests", .tags(.stringComposition))
struct StringDynamicPropertyTests {

    @propertyWrapper
    private struct Recorder: StringDynamicProperty {

        let box = Box()

        var wrappedValue: String {
            "lineSpacing=\(box.lineSpacing),updates=\(box.updates)"
        }

        func update(in environment: StringEnvironmentValues) {
            box.lineSpacing = environment.lineSpacing
            box.updates += 1
        }

        final class Box {
            var lineSpacing: Int = -1
            var updates: Int = 0
        }

    }

    @propertyWrapper
    private struct Derived: StringDynamicProperty {

        @StringEnvironment(\.lineSpacing)
        private var spacing: Int

        let box = Box()

        var wrappedValue: Int {
            box.value
        }

        func update(in environment: StringEnvironmentValues) {
            // Reads from the inner @StringEnvironment, which is updated first by the
            // recursive walk. If recursion were broken, `spacing` would be the
            // default and `box.value` would be wrong.
            box.value = spacing
        }

        final class Box {
            var value: Int = -1
        }

    }

    @propertyWrapper
    private struct Outer: StringDynamicProperty {

        @Derived
        private var derived: Int

        let box = Box()

        var wrappedValue: Int {
            box.value
        }

        func update(in environment: StringEnvironmentValues) {
            // Two levels of nesting: Outer wraps Derived which wraps @StringEnvironment.
            box.value = derived
        }

        final class Box {
            var value: Int = -1
        }

    }

    @Test("update(in:) is called before body")
    func updateCalledBeforeBody() {

        struct Reader: StringComponent {

            @Recorder
            var recorded: String

            var body: some StringComponent {
                recorded
            }

        }

        let component = Reader().environment(\.lineSpacing, 7)
        #expect(String(component) == "lineSpacing=7,updates=1")
    }

    @Test("Recurses into nested @StringEnvironment")
    func recursesIntoNestedStringEnvironment() {

        struct Reader: StringComponent {

            @Derived
            var spacing: Int

            var body: some StringComponent {
                "\(spacing)"
            }

        }

        let component = Reader().environment(\.lineSpacing, 5)
        #expect(String(component) == "5")
    }

    @Test("Recurses into nested custom dynamic property")
    func recursesIntoNestedCustomDynamicProperty() {

        struct Reader: StringComponent {

            @Outer
            var spacing: Int

            var body: some StringComponent {
                "\(spacing)"
            }

        }

        let component = Reader().environment(\.lineSpacing, 9)
        #expect(String(component) == "9")
    }

    @Test("Sibling dynamic properties all updated")
    func siblingDynamicPropertiesAllUpdated() {

        struct Reader: StringComponent {

            @Recorder
            var first: String

            @Recorder
            var second: String

            var body: some StringComponent {
                Line {
                    first
                    "|"
                    second
                }
            }

        }

        let component = Reader().environment(\.lineSpacing, 3)
        #expect(String(component) == "lineSpacing=3,updates=1|lineSpacing=3,updates=1")
    }

}
