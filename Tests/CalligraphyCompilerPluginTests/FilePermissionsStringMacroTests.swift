// Calligraphy
// FilePermissionsStringMacroTests.swift
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
        "filePermissions": MacroSpec(type: FilePermissionsStringMacro.self)
    ]
#endif

@Suite("#filePermissions(string) Macro Tests")
struct FilePermissionsStringMacroTests {

    @Test("Expands rwxr-xr-x")
    func expandsRwxrxrx() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                """
                let perms: FilePermissions = #filePermissions("rwxr-xr-x")
                """,
                expandedSource: """
                let perms: FilePermissions = [.readUser, .writeUser, .executeUser, .readGroup, .executeGroup, .readOther, .executeOther]
                """,
                macroSpecs: macroSpecs
            ) { failure in
                Issue.record("\(failure.message)")
            }
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

    @Test("Strips leading file type and whitespace")
    func leadingTypeAndWhitespace() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                """
                let perms: FilePermissions = #filePermissions("-rwx r-x r-x")
                """,
                expandedSource: """
                let perms: FilePermissions = [.readUser, .writeUser, .executeUser, .readGroup, .executeGroup, .readOther, .executeOther]
                """,
                macroSpecs: macroSpecs
            ) { failure in
                Issue.record("\(failure.message)")
            }
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

    @Test("Uppercase S without execute encodes setuid only")
    func setuidUppercaseSNoExec() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                """
                let perms: FilePermissions = #filePermissions("rwSr-xr-x")
                """,
                expandedSource: """
                let perms: FilePermissions = [.setUserID, .readUser, .writeUser, .readGroup, .executeGroup, .readOther, .executeOther]
                """,
                macroSpecs: macroSpecs
            ) { failure in
                Issue.record("\(failure.message)")
            }
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

    @Test("Uppercase T without execute encodes sticky only")
    func stickyUppercaseTNoExec() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                """
                let perms: FilePermissions = #filePermissions("rwxr-xr-T")
                """,
                expandedSource: """
                let perms: FilePermissions = [.sticky, .readUser, .writeUser, .executeUser, .readGroup, .executeGroup, .readOther]
                """,
                macroSpecs: macroSpecs
            ) { failure in
                Issue.record("\(failure.message)")
            }
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

    @Test("All dashes encode empty permissions")
    func allDashesEmpty() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                """
                let perms: FilePermissions = #filePermissions("---------")
                """,
                expandedSource: """
                let perms: FilePermissions = [] as FilePermissions
                """,
                macroSpecs: macroSpecs
            ) { failure in
                Issue.record("\(failure.message)")
            }
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

    @Test("All bits encode every permission")
    func allBitsRwsrwsrwt() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                """
                let perms: FilePermissions = #filePermissions("rwsrwsrwt")
                """,
                expandedSource: """
                let perms: FilePermissions = [.setUserID, .setGroupID, .sticky, .readUser, .writeUser, .executeUser, .readGroup, .writeGroup, .executeGroup, .readOther, .writeOther, .executeOther]
                """,
                macroSpecs: macroSpecs
            ) { failure in
                Issue.record("\(failure.message)")
            }
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

    @Test("Wrong length emits diagnostic")
    func invalidWrongLength() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                """
                let perms: FilePermissions = #filePermissions("rwx")
                """,
                expandedSource: """
                let perms: FilePermissions = #filePermissions("rwx")
                """,
                diagnostics: [
                    DiagnosticSpec(message: "filePermissions string must describe exactly 9 permission characters (optionally preceded by a file type), e.g. \"rwxr-xr-x\" or \"-rwxr-xr-x\"", line: 1, column: 30)
                ],
                macroSpecs: macroSpecs
            ) { failure in
                Issue.record("\(failure.message)")
            }
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

    @Test("Interpolated string emits diagnostic")
    func invalidInterpolation() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                #"""
                let perms: FilePermissions = #filePermissions("rwxr-\(1)r-x")
                """#,
                expandedSource: #"""
                let perms: FilePermissions = #filePermissions("rwxr-\(1)r-x")
                """#,
                diagnostics: [
                    DiagnosticSpec(message: "filePermissions string must be a simple, static string literal without interpolation", line: 1, column: 30)
                ],
                macroSpecs: macroSpecs
            ) { failure in
                Issue.record("\(failure.message)")
            }
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

    @Test("Out-of-set character emits diagnostic")
    func invalidCharacterOutOfSet() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                """
                let perms: FilePermissions = #filePermissions("rwxrqxr-x")
                """,
                expandedSource: """
                let perms: FilePermissions = #filePermissions("rwxrqxr-x")
                """,
                diagnostics: [
                    DiagnosticSpec(message: "invalid character at position 4 in permission string: rwxrqxr-x", line: 1, column: 30)
                ],
                macroSpecs: macroSpecs
            ) { failure in
                Issue.record("\(failure.message)")
            }
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

    @Test("Invalid other-execute position emits diagnostic")
    func invalidOtherExecutePosition() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                """
                let perms: FilePermissions = #filePermissions("rwxr-xr-s")
                """,
                expandedSource: """
                let perms: FilePermissions = #filePermissions("rwxr-xr-s")
                """,
                diagnostics: [
                    DiagnosticSpec(message: "invalid character at position 8 in permission string: rwxr-xr-s", line: 1, column: 30)
                ],
                macroSpecs: macroSpecs
            ) { failure in
                Issue.record("\(failure.message)")
            }
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

    @Test("Missing argument emits diagnostic")
    func invalidNoArgument() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                """
                let perms: FilePermissions = #filePermissions()
                """,
                expandedSource: """
                let perms: FilePermissions = #filePermissions()
                """,
                diagnostics: [
                    DiagnosticSpec(message: "filePermissions requires a single string literal argument, e.g. \"rwxr-xr-x\"", line: 1, column: 30)
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
