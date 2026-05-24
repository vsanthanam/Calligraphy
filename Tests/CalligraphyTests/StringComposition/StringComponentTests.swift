// Calligraphy
// StringComponentTests.swift
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

@Suite("String Component Tests", .tags(.stringComposition))
struct StringComponentTests {

    @Test("Body Renders")
    func bodyRenders() {

        struct Greeting: StringComponent {
            var body: some StringComponent {
                "Hello, World!"
            }
        }

        #expect(String(Greeting()) == "Hello, World!")
    }

    @Test("Custom Render Overrides Body")
    func customRender() {

        struct Custom: StringComponent {

            var body: Never {
                fatalErrorImperativeStringComponent()
            }

            func render(in environment: StringEnvironmentValues) -> String? {
                "rendered"
            }

        }

        #expect(String(Custom()) == "rendered")
    }

    @Test("Render Returning Nil Yields Empty String")
    func nilRender() {

        struct Empty: StringComponent {

            var body: Never {
                fatalErrorImperativeStringComponent()
            }

            func render(in environment: StringEnvironmentValues) -> String? {
                nil
            }

        }

        #expect(String(Empty()) == "")
    }

    @Test("Default Render Injects Environment Into Property Wrappers")
    func environmentInjection() {

        struct Reader: StringComponent {

            @StringEnvironment(\.separator)
            var separator: String

            var body: some StringComponent {
                separator
            }

        }

        let component = Reader()
            .environment(\.separator, "|")
        #expect(String(component) == "|")
    }

}
