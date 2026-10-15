// Calligraphy
// EntryMacroTests.swift
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

#if canImport(SwiftSyntax604)
    import SwiftSyntaxMacrosTestSupport
#endif

#if canImport(CalligraphyCompilerPlugin)
    import CalligraphyCompilerPlugin

    private let macroSpecs: [String: MacroSpec] = [
        "Entry": MacroSpec(type: EntryMacro.self)
    ]
#endif

@Suite("@Entry Macro Tests")
struct EntryMacroTests {

    #if compiler(>=6.3) && canImport(SwiftSyntax603)
        @Test("String type entry expands")
        func stringEntry() {
            #if canImport(CalligraphyCompilerPlugin)
                assertMacroExpansion(
                    #"""
                    extension EnvironmentValues {
                        @Entry
                        var separator: String = "\n"
                    }
                    """#,
                    expandedSource: #"""
                    extension EnvironmentValues {
                        var separator: String {
                            get {
                                self[__Key_separator.self]
                            }
                            set {
                                self[__Key_separator.self] = newValue
                            }
                        }

                        private struct __Key_separator: Calligraphy::EnvironmentKey {
                            static let defaultValue: String = "\n"
                        }
                    }
                    """#,
                    macroSpecs: macroSpecs
                )
            #else
                Issue.record("macros are only supported when running tests for the host platform")
            #endif
        }
    #else
        @Test("String type entry expands")
        func stringEntry() {
            #if canImport(CalligraphyCompilerPlugin)
                assertMacroExpansion(
                    #"""
                    extension EnvironmentValues {
                        @Entry
                        var separator: String = "\n"
                    }
                    """#,
                    expandedSource: #"""
                    extension EnvironmentValues {
                        var separator: String {
                            get {
                                self[__Key_separator.self]
                            }
                            set {
                                self[__Key_separator.self] = newValue
                            }
                        }

                        private struct __Key_separator: Calligraphy.EnvironmentKey {
                            static let defaultValue: String = "\n"
                        }
                    }
                    """#,
                    macroSpecs: macroSpecs
                )
            #else
                Issue.record("macros are only supported when running tests for the host platform")
            #endif
        }
    #endif

    #if compiler(>=6.3) && canImport(SwiftSyntax603)
        @Test("Int type entry expands")
        func intEntry() {
            #if canImport(CalligraphyCompilerPlugin)
                assertMacroExpansion(
                    """
                    extension EnvironmentValues {
                        @Entry
                        var lineSpacing: Int = 1
                    }
                    """,
                    expandedSource: """
                    extension EnvironmentValues {
                        var lineSpacing: Int {
                            get {
                                self[__Key_lineSpacing.self]
                            }
                            set {
                                self[__Key_lineSpacing.self] = newValue
                            }
                        }

                        private struct __Key_lineSpacing: Calligraphy::EnvironmentKey {
                            static let defaultValue: Int = 1
                        }
                    }
                    """,
                    macroSpecs: macroSpecs
                )
            #else
                Issue.record("macros are only supported when running tests for the host platform")
            #endif
        }
    #else
        @Test("Int type entry expands")
        func intEntry() {
            #if canImport(CalligraphyCompilerPlugin)
                assertMacroExpansion(
                    """
                    extension EnvironmentValues {
                        @Entry
                        var lineSpacing: Int = 1
                    }
                    """,
                    expandedSource: """
                    extension EnvironmentValues {
                        var lineSpacing: Int {
                            get {
                                self[__Key_lineSpacing.self]
                            }
                            set {
                                self[__Key_lineSpacing.self] = newValue
                            }
                        }

                        private struct __Key_lineSpacing: Calligraphy.EnvironmentKey {
                            static let defaultValue: Int = 1
                        }
                    }
                    """,
                    macroSpecs: macroSpecs
                )
            #else
                Issue.record("macros are only supported when running tests for the host platform")
            #endif
        }
    #endif

    #if compiler(>=6.3) && canImport(SwiftSyntax603)
        @Test("Access level is preserved")
        func preservesAccessLevel() {
            #if canImport(CalligraphyCompilerPlugin)
                assertMacroExpansion(
                    #"""
                    extension EnvironmentValues {
                        @Entry
                        public var separator: String = "\n"
                    }
                    """#,
                    expandedSource: #"""
                    extension EnvironmentValues {
                        public var separator: String {
                            get {
                                self[__Key_separator.self]
                            }
                            set {
                                self[__Key_separator.self] = newValue
                            }
                        }

                        private struct __Key_separator: Calligraphy::EnvironmentKey {
                            static let defaultValue: String = "\n"
                        }
                    }
                    """#,
                    macroSpecs: macroSpecs
                )
            #else
                Issue.record("macros are only supported when running tests for the host platform")
            #endif
        }
    #else
        @Test("Access level is preserved")
        func preservesAccessLevel() {
            #if canImport(CalligraphyCompilerPlugin)
                assertMacroExpansion(
                    #"""
                    extension EnvironmentValues {
                        @Entry
                        public var separator: String = "\n"
                    }
                    """#,
                    expandedSource: #"""
                    extension EnvironmentValues {
                        public var separator: String {
                            get {
                                self[__Key_separator.self]
                            }
                            set {
                                self[__Key_separator.self] = newValue
                            }
                        }

                        private struct __Key_separator: Calligraphy.EnvironmentKey {
                            static let defaultValue: String = "\n"
                        }
                    }
                    """#,
                    macroSpecs: macroSpecs
                )
            #else
                Issue.record("macros are only supported when running tests for the host platform")
            #endif
        }
    #endif

    #if compiler(>=6.3) && canImport(SwiftSyntax603)
        @Test("Custom type entry expands")
        func customTypeEntry() {
            #if canImport(CalligraphyCompilerPlugin)
                assertMacroExpansion(
                    """
                    extension EnvironmentValues {
                        @Entry
                        var style: QuotationMarkStyle = .default
                    }
                    """,
                    expandedSource: """
                    extension EnvironmentValues {
                        var style: QuotationMarkStyle {
                            get {
                                self[__Key_style.self]
                            }
                            set {
                                self[__Key_style.self] = newValue
                            }
                        }

                        private struct __Key_style: Calligraphy::EnvironmentKey {
                            static let defaultValue: QuotationMarkStyle = .default
                        }
                    }
                    """,
                    macroSpecs: macroSpecs
                )
            #else
                Issue.record("macros are only supported when running tests for the host platform")
            #endif
        }
    #else
        @Test("Custom type entry expands")
        func customTypeEntry() {
            #if canImport(CalligraphyCompilerPlugin)
                assertMacroExpansion(
                    """
                    extension EnvironmentValues {
                        @Entry
                        var style: QuotationMarkStyle = .default
                    }
                    """,
                    expandedSource: """
                    extension EnvironmentValues {
                        var style: QuotationMarkStyle {
                            get {
                                self[__Key_style.self]
                            }
                            set {
                                self[__Key_style.self] = newValue
                            }
                        }

                        private struct __Key_style: Calligraphy.EnvironmentKey {
                            static let defaultValue: QuotationMarkStyle = .default
                        }
                    }
                    """,
                    macroSpecs: macroSpecs
                )
            #else
                Issue.record("macros are only supported when running tests for the host platform")
            #endif
        }
    #endif

    #if compiler(>=6.3) && canImport(SwiftSyntax603)
        @Test("Optional type without initial value defaults to nil")
        func optionalTypeDefaultsToNil() {
            #if canImport(CalligraphyCompilerPlugin)
                assertMacroExpansion(
                    """
                    extension EnvironmentValues {
                        @Entry
                        var prefix: String?
                    }
                    """,
                    expandedSource: """
                    extension EnvironmentValues {
                        var prefix: String? {
                            get {
                                self[__Key_prefix.self]
                            }
                            set {
                                self[__Key_prefix.self] = newValue
                            }
                        }

                        private struct __Key_prefix: Calligraphy::EnvironmentKey {
                            static let defaultValue: String? = nil
                        }
                    }
                    """,
                    macroSpecs: macroSpecs
                )
            #else
                Issue.record("macros are only supported when running tests for the host platform")
            #endif
        }
    #else
        @Test("Optional type without initial value defaults to nil")
        func optionalTypeDefaultsToNil() {
            #if canImport(CalligraphyCompilerPlugin)
                assertMacroExpansion(
                    """
                    extension EnvironmentValues {
                        @Entry
                        var prefix: String?
                    }
                    """,
                    expandedSource: """
                    extension EnvironmentValues {
                        var prefix: String? {
                            get {
                                self[__Key_prefix.self]
                            }
                            set {
                                self[__Key_prefix.self] = newValue
                            }
                        }

                        private struct __Key_prefix: Calligraphy.EnvironmentKey {
                            static let defaultValue: String? = nil
                        }
                    }
                    """,
                    macroSpecs: macroSpecs
                )
            #else
                Issue.record("macros are only supported when running tests for the host platform")
            #endif
        }
    #endif

    #if compiler(>=6.3) && canImport(SwiftSyntax603)
        @Test("Optional<T> long form without initial value defaults to nil")
        func optionalLongFormDefaultsToNil() {
            #if canImport(CalligraphyCompilerPlugin)
                assertMacroExpansion(
                    """
                    extension EnvironmentValues {
                        @Entry
                        var prefix: Optional<String>
                    }
                    """,
                    expandedSource: """
                    extension EnvironmentValues {
                        var prefix: Optional<String> {
                            get {
                                self[__Key_prefix.self]
                            }
                            set {
                                self[__Key_prefix.self] = newValue
                            }
                        }

                        private struct __Key_prefix: Calligraphy::EnvironmentKey {
                            static let defaultValue: Optional<String> = nil
                        }
                    }
                    """,
                    macroSpecs: macroSpecs
                )
            #else
                Issue.record("macros are only supported when running tests for the host platform")
            #endif
        }
    #else
        @Test("Optional<T> long form without initial value defaults to nil")
        func optionalLongFormDefaultsToNil() {
            #if canImport(CalligraphyCompilerPlugin)
                assertMacroExpansion(
                    """
                    extension EnvironmentValues {
                        @Entry
                        var prefix: Optional<String>
                    }
                    """,
                    expandedSource: """
                    extension EnvironmentValues {
                        var prefix: Optional<String> {
                            get {
                                self[__Key_prefix.self]
                            }
                            set {
                                self[__Key_prefix.self] = newValue
                            }
                        }

                        private struct __Key_prefix: Calligraphy.EnvironmentKey {
                            static let defaultValue: Optional<String> = nil
                        }
                    }
                    """,
                    macroSpecs: macroSpecs
                )
            #else
                Issue.record("macros are only supported when running tests for the host platform")
            #endif
        }
    #endif

    #if compiler(>=6.3) && canImport(SwiftSyntax603)
        @Test("Swift.Optional<T> without initial value defaults to nil")
        func memberQualifiedOptionalDefaultsToNil() {
            #if canImport(CalligraphyCompilerPlugin)
                assertMacroExpansion(
                    """
                    extension EnvironmentValues {
                        @Entry
                        var prefix: Swift.Optional<String>
                    }
                    """,
                    expandedSource: """
                    extension EnvironmentValues {
                        var prefix: Swift.Optional<String> {
                            get {
                                self[__Key_prefix.self]
                            }
                            set {
                                self[__Key_prefix.self] = newValue
                            }
                        }

                        private struct __Key_prefix: Calligraphy::EnvironmentKey {
                            static let defaultValue: Swift.Optional<String> = nil
                        }
                    }
                    """,
                    macroSpecs: macroSpecs
                )
            #else
                Issue.record("macros are only supported when running tests for the host platform")
            #endif
        }
    #else
        @Test("Swift.Optional<T> without initial value defaults to nil")
        func memberQualifiedOptionalDefaultsToNil() {
            #if canImport(CalligraphyCompilerPlugin)
                assertMacroExpansion(
                    """
                    extension EnvironmentValues {
                        @Entry
                        var prefix: Swift.Optional<String>
                    }
                    """,
                    expandedSource: """
                    extension EnvironmentValues {
                        var prefix: Swift.Optional<String> {
                            get {
                                self[__Key_prefix.self]
                            }
                            set {
                                self[__Key_prefix.self] = newValue
                            }
                        }

                        private struct __Key_prefix: Calligraphy.EnvironmentKey {
                            static let defaultValue: Swift.Optional<String> = nil
                        }
                    }
                    """,
                    macroSpecs: macroSpecs
                )
            #else
                Issue.record("macros are only supported when running tests for the host platform")
            #endif
        }
    #endif

    #if canImport(SwiftSyntax603)
        #if compiler(>=6.3) && canImport(SwiftSyntax603)
            @Test("Swift::Optional<T> without initial value defaults to nil")
            func moduleSelectorOptionalDefaultsToNil() {
                #if canImport(CalligraphyCompilerPlugin)
                    assertMacroExpansion(
                        """
                        extension EnvironmentValues {
                            @Entry
                            var prefix: Swift::Optional<String>
                        }
                        """,
                        expandedSource: """
                        extension EnvironmentValues {
                            var prefix: Swift::Optional<String> {
                                get {
                                    self[__Key_prefix.self]
                                }
                                set {
                                    self[__Key_prefix.self] = newValue
                                }
                            }

                            private struct __Key_prefix: Calligraphy::EnvironmentKey {
                                static let defaultValue: Swift::Optional<String> = nil
                            }
                        }
                        """,
                        macroSpecs: macroSpecs
                    )
                #else
                    Issue.record("macros are only supported when running tests for the host platform")
                #endif
            }
        #else
            @Test("Swift::Optional<T> without initial value defaults to nil")
            func moduleSelectorOptionalDefaultsToNil() {
                #if canImport(CalligraphyCompilerPlugin)
                    assertMacroExpansion(
                        """
                        extension EnvironmentValues {
                            @Entry
                            var prefix: Swift::Optional<String>
                        }
                        """,
                        expandedSource: """
                        extension EnvironmentValues {
                            var prefix: Swift::Optional<String> {
                                get {
                                    self[__Key_prefix.self]
                                }
                                set {
                                    self[__Key_prefix.self] = newValue
                                }
                            }

                            private struct __Key_prefix: Calligraphy.EnvironmentKey {
                                static let defaultValue: Swift::Optional<String> = nil
                            }
                        }
                        """,
                        macroSpecs: macroSpecs
                    )
                #else
                    Issue.record("macros are only supported when running tests for the host platform")
                #endif
            }
        #endif

        @Test("Optional from another module requires an initial value")
        func foreignOptionalRequiresInitialValue() {
            #if canImport(CalligraphyCompilerPlugin)
                assertMacroExpansion(
                    """
                    extension EnvironmentValues {
                        @Entry
                        var prefix: Foo::Optional<String>
                    }
                    """,
                    expandedSource: """
                    extension EnvironmentValues {
                        var prefix: Foo::Optional<String> {
                            get {
                                self[__Key_prefix.self]
                            }
                            set {
                                self[__Key_prefix.self] = newValue
                            }
                        }
                    }
                    """,
                    diagnostics: [
                        DiagnosticSpec(message: "@Entry requires an initial value for non-optional types", line: 2, column: 5)
                    ],
                    macroSpecs: macroSpecs
                )
            #else
                Issue.record("macros are only supported when running tests for the host platform")
            #endif
        }
    #endif

    #if compiler(>=6.3) && canImport(SwiftSyntax603)
        @Test("Implicitly unwrapped optional without initial value defaults to nil")
        func implicitlyUnwrappedOptionalDefaultsToNil() {
            #if canImport(CalligraphyCompilerPlugin)
                assertMacroExpansion(
                    """
                    extension EnvironmentValues {
                        @Entry
                        var prefix: String!
                    }
                    """,
                    expandedSource: """
                    extension EnvironmentValues {
                        var prefix: String! {
                            get {
                                self[__Key_prefix.self]
                            }
                            set {
                                self[__Key_prefix.self] = newValue
                            }
                        }

                        private struct __Key_prefix: Calligraphy::EnvironmentKey {
                            static let defaultValue: String! = nil
                        }
                    }
                    """,
                    macroSpecs: macroSpecs
                )
            #else
                Issue.record("macros are only supported when running tests for the host platform")
            #endif
        }
    #else
        @Test("Implicitly unwrapped optional without initial value defaults to nil")
        func implicitlyUnwrappedOptionalDefaultsToNil() {
            #if canImport(CalligraphyCompilerPlugin)
                assertMacroExpansion(
                    """
                    extension EnvironmentValues {
                        @Entry
                        var prefix: String!
                    }
                    """,
                    expandedSource: """
                    extension EnvironmentValues {
                        var prefix: String! {
                            get {
                                self[__Key_prefix.self]
                            }
                            set {
                                self[__Key_prefix.self] = newValue
                            }
                        }

                        private struct __Key_prefix: Calligraphy.EnvironmentKey {
                            static let defaultValue: String! = nil
                        }
                    }
                    """,
                    macroSpecs: macroSpecs
                )
            #else
                Issue.record("macros are only supported when running tests for the host platform")
            #endif
        }
    #endif

    #if compiler(>=6.3) && canImport(SwiftSyntax603)
        @Test("Optional type with explicit initial value is preserved")
        func optionalTypeWithExplicitValue() {
            #if canImport(CalligraphyCompilerPlugin)
                assertMacroExpansion(
                    #"""
                    extension EnvironmentValues {
                        @Entry
                        var prefix: String? = "default"
                    }
                    """#,
                    expandedSource: #"""
                    extension EnvironmentValues {
                        var prefix: String? {
                            get {
                                self[__Key_prefix.self]
                            }
                            set {
                                self[__Key_prefix.self] = newValue
                            }
                        }

                        private struct __Key_prefix: Calligraphy::EnvironmentKey {
                            static let defaultValue: String? = "default"
                        }
                    }
                    """#,
                    macroSpecs: macroSpecs
                )
            #else
                Issue.record("macros are only supported when running tests for the host platform")
            #endif
        }
    #else
        @Test("Optional type with explicit initial value is preserved")
        func optionalTypeWithExplicitValue() {
            #if canImport(CalligraphyCompilerPlugin)
                assertMacroExpansion(
                    #"""
                    extension EnvironmentValues {
                        @Entry
                        var prefix: String? = "default"
                    }
                    """#,
                    expandedSource: #"""
                    extension EnvironmentValues {
                        var prefix: String? {
                            get {
                                self[__Key_prefix.self]
                            }
                            set {
                                self[__Key_prefix.self] = newValue
                            }
                        }

                        private struct __Key_prefix: Calligraphy.EnvironmentKey {
                            static let defaultValue: String? = "default"
                        }
                    }
                    """#,
                    macroSpecs: macroSpecs
                )
            #else
                Issue.record("macros are only supported when running tests for the host platform")
            #endif
        }
    #endif

    @Test("Missing type annotation emits diagnostic")
    func requiresTypeAnnotation() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                #"""
                extension EnvironmentValues {
                    @Entry
                    var separator = "\n"
                }
                """#,
                expandedSource: #"""
                extension EnvironmentValues {
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
                    DiagnosticSpec(message: "@Entry requires an explicit type annotation", line: 2, column: 5)
                ],
                macroSpecs: macroSpecs
            )
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

    @Test("Missing initial value emits diagnostic")
    func requiresInitialValue() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                """
                extension EnvironmentValues {
                    @Entry
                    var separator: String
                }
                """,
                expandedSource: """
                extension EnvironmentValues {
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
                    DiagnosticSpec(message: "@Entry requires an initial value for non-optional types", line: 2, column: 5)
                ],
                macroSpecs: macroSpecs
            )
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

}
