// Calligraphy
// FilePermissionsOctalMacroTests.swift
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
        "filePermissions": MacroSpec(type: FilePermissionsOctalMacro.self)
    ]
#endif

@Suite("#filePermissions(octal) Macro Tests")
struct FilePermissionsOctalMacroTests {

    @Test("Expands 0o644")
    func expands0644() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                """
                let perms: FilePermissions = #filePermissions(0o644)
                """,
                expandedSource: """
                let perms: FilePermissions = [.readUser, .writeUser, .readGroup, .readOther]
                """,
                macroSpecs: macroSpecs
            ) { failure in
                Issue.record("\(failure.message)")
            }
        #else
            Issue.record("macros are only supported when running tests for the host platform")
        #endif
    }

    @Test("Expands 0o755")
    func expands0755() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                """
                let perms: FilePermissions = #filePermissions(0o755)
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

    @Test("Expands 0o7777 (all bits)")
    func expands07777() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                """
                let perms: FilePermissions = #filePermissions(0o7777)
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

    @Test("Expands 0o000 (empty)")
    func expands0000() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                """
                let perms: FilePermissions = #filePermissions(0o000)
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

    @Test("Underscores allowed in literal")
    func underscoresAllowed() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                """
                let perms: FilePermissions = #filePermissions(0o7_5_5)
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

    @Test("Non-octal literal emits diagnostic")
    func invalidLiteral() {
        #if canImport(CalligraphyCompilerPlugin)
            assertMacroExpansion(
                """
                let perms: FilePermissions = #filePermissions(755)
                """,
                expandedSource: """
                let perms: FilePermissions = #filePermissions(755)
                """,
                diagnostics: [
                    DiagnosticSpec(message: "filePermissions requires an octal integer literal", line: 1, column: 30)
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
