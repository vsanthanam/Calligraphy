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

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacros
import SwiftSyntaxMacrosGenericTestSupport
import Testing

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(CalligraphyCompilerPlugin)
    import CalligraphyCompilerPlugin

    private let macroSpecs: [String: MacroSpec] = [
        "StringEntry": MacroSpec(type: StringEntryMacro.self)
    ]
#endif

@Suite("@StringEntry Macro Tests")
struct StringEntryMacroTests {

    @Test("String type entry expands")
    func stringEntry() {
        #if canImport(CalligraphyCompilerPlugin)
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
                macroSpecs: macroSpecs
            ) { failure in
                Issue.record("\(failure.message)")
            }
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

    @Test("Int type entry expands")
    func intEntry() {
        #if canImport(CalligraphyCompilerPlugin)
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
                macroSpecs: macroSpecs
            ) { failure in
                Issue.record("\(failure.message)")
            }
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

    @Test("Access level is preserved")
    func preservesAccessLevel() {
        #if canImport(CalligraphyCompilerPlugin)
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
                macroSpecs: macroSpecs
            ) { failure in
                Issue.record("\(failure.message)")
            }
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

    @Test("Custom type entry expands")
    func customTypeEntry() {
        #if canImport(CalligraphyCompilerPlugin)
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
                macroSpecs: macroSpecs
            ) { failure in
                Issue.record("\(failure.message)")
            }
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

    @Test("Optional type without initial value defaults to nil")
    func optionalTypeDefaultsToNil() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                """
                extension StringEnvironmentValues {
                    @StringEntry
                    var prefix: String?
                }
                """,
                expandedSource: """
                extension StringEnvironmentValues {
                    var prefix: String? {
                        get {
                            self[__Key_prefix.self]
                        }
                        set {
                            self[__Key_prefix.self] = newValue
                        }
                    }

                    private struct __Key_prefix: StringEnvironmentKey {
                        static let defaultValue: String? = nil
                    }
                }
                """,
                macroSpecs: macroSpecs
            ) { failure in
                Issue.record("\(failure.message)")
            }
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

    @Test("Optional<T> long form without initial value defaults to nil")
    func optionalLongFormDefaultsToNil() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                """
                extension StringEnvironmentValues {
                    @StringEntry
                    var prefix: Optional<String>
                }
                """,
                expandedSource: """
                extension StringEnvironmentValues {
                    var prefix: Optional<String> {
                        get {
                            self[__Key_prefix.self]
                        }
                        set {
                            self[__Key_prefix.self] = newValue
                        }
                    }

                    private struct __Key_prefix: StringEnvironmentKey {
                        static let defaultValue: Optional<String> = nil
                    }
                }
                """,
                macroSpecs: macroSpecs
            ) { failure in
                Issue.record("\(failure.message)")
            }
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

    @Test("Implicitly unwrapped optional without initial value defaults to nil")
    func implicitlyUnwrappedOptionalDefaultsToNil() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                """
                extension StringEnvironmentValues {
                    @StringEntry
                    var prefix: String!
                }
                """,
                expandedSource: """
                extension StringEnvironmentValues {
                    var prefix: String! {
                        get {
                            self[__Key_prefix.self]
                        }
                        set {
                            self[__Key_prefix.self] = newValue
                        }
                    }

                    private struct __Key_prefix: StringEnvironmentKey {
                        static let defaultValue: String! = nil
                    }
                }
                """,
                macroSpecs: macroSpecs
            ) { failure in
                Issue.record("\(failure.message)")
            }
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

    @Test("Optional type with explicit initial value is preserved")
    func optionalTypeWithExplicitValue() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                #"""
                extension StringEnvironmentValues {
                    @StringEntry
                    var prefix: String? = "default"
                }
                """#,
                expandedSource: #"""
                extension StringEnvironmentValues {
                    var prefix: String? {
                        get {
                            self[__Key_prefix.self]
                        }
                        set {
                            self[__Key_prefix.self] = newValue
                        }
                    }

                    private struct __Key_prefix: StringEnvironmentKey {
                        static let defaultValue: String? = "default"
                    }
                }
                """#,
                macroSpecs: macroSpecs
            ) { failure in
                Issue.record("\(failure.message)")
            }
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

    @Test("Missing type annotation emits diagnostic")
    func requiresTypeAnnotation() {
        #if canImport(CalligraphyCompilerPlugin)
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
                    DiagnosticSpec(message: "@StringEntry requires an explicit type annotation", line: 2, column: 5)
                ],
                macroSpecs: macroSpecs
            ) { failure in
                Issue.record("\(failure.message)")
            }
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

    @Test("Missing initial value emits diagnostic")
    func requiresInitialValue() {
        #if canImport(CalligraphyCompilerPlugin)
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
                    DiagnosticSpec(message: "@StringEntry requires an initial value for non-optional types", line: 2, column: 5)
                ],
                macroSpecs: macroSpecs
            ) { failure in
                Issue.record("\(failure.message)")
            }
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

}
