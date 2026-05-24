// Calligraphy
// StringEntryMacroTests.swift
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

@testable import CalligraphyCompilerPlugin
import SwiftSyntaxMacros
import SwiftSyntaxMacrosGenericTestSupport
import SwiftSyntaxMacrosTestSupport
import XCTest

final class StringEntryMacroTests: XCTestCase {

    private let macros: [String: any Macro.Type] = [
        "StringEntry": StringEntryMacro.self
    ]

    func testExpandsStringEntry() {
        assertMacroExpansion(
            #"""
            extension StringEnvironmentValues {
                @StringEntry
                var separator: String = "\n"
            }
            """#,
            expandedSource: #"""
            extension StringEnvironmentValues {
                var separator: String {
                    get {
                        self[__Key_separator.self]
                    }
                    set {
                        self[__Key_separator.self] = newValue
                    }
                }

                private struct __Key_separator: StringEnvironmentKey {
                    static let defaultValue: String = "\n"
                }
            }
            """#,
            macros: macros
        )
    }

    func testExpandsIntEntry() {
        assertMacroExpansion(
            """
            extension StringEnvironmentValues {
                @StringEntry
                var lineSpacing: Int = 1
            }
            """,
            expandedSource: """
            extension StringEnvironmentValues {
                var lineSpacing: Int {
                    get {
                        self[__Key_lineSpacing.self]
                    }
                    set {
                        self[__Key_lineSpacing.self] = newValue
                    }
                }

                private struct __Key_lineSpacing: StringEnvironmentKey {
                    static let defaultValue: Int = 1
                }
            }
            """,
            macros: macros
        )
    }

    func testPreservesAccessLevel() {
        assertMacroExpansion(
            #"""
            extension StringEnvironmentValues {
                @StringEntry
                public var separator: String = "\n"
            }
            """#,
            expandedSource: #"""
            extension StringEnvironmentValues {
                public var separator: String {
                    get {
                        self[__Key_separator.self]
                    }
                    set {
                        self[__Key_separator.self] = newValue
                    }
                }

                private struct __Key_separator: StringEnvironmentKey {
                    static let defaultValue: String = "\n"
                }
            }
            """#,
            macros: macros
        )
    }

    func testExpandsCustomTypeEntry() {
        assertMacroExpansion(
            """
            extension StringEnvironmentValues {
                @StringEntry
                var style: QuotationMarkStyle = .default
            }
            """,
            expandedSource: """
            extension StringEnvironmentValues {
                var style: QuotationMarkStyle {
                    get {
                        self[__Key_style.self]
                    }
                    set {
                        self[__Key_style.self] = newValue
                    }
                }

                private struct __Key_style: StringEnvironmentKey {
                    static let defaultValue: QuotationMarkStyle = .default
                }
            }
            """,
            macros: macros
        )
    }

    func testRequiresTypeAnnotation() {
        assertMacroExpansion(
            #"""
            extension StringEnvironmentValues {
                @StringEntry
                var separator = "\n"
            }
            """#,
            expandedSource: #"""
            extension StringEnvironmentValues {
                var separator {
                    get {
                        self[__Key_separator.self]
                    }
                    set {
                        self[__Key_separator.self] = newValue
                    }
                }
            }
            """#,
            diagnostics: [
                .init(message: "@StringEntry requires an explicit type annotation", line: 2, column: 5)
            ],
            macros: macros
        )
    }

    func testRequiresInitialValue() {
        assertMacroExpansion(
            """
            extension StringEnvironmentValues {
                @StringEntry
                var separator: String
            }
            """,
            expandedSource: """
            extension StringEnvironmentValues {
                var separator: String {
                    get {
                        self[__Key_separator.self]
                    }
                    set {
                        self[__Key_separator.self] = newValue
                    }
                }
            }
            """,
            diagnostics: [
                .init(message: "@StringEntry requires an initial value", line: 2, column: 5)
            ],
            macros: macros
        )
    }

}
