// Calligraphy
// FilePermissionsStringMacroTests.swift
//
// MIT License
//
// Copyright (c) 2025 Varun Santhanam
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

final class FilePermissionsStringMacroTests: XCTestCase {

    private let macros: [String: any Macro.Type] = [
        "filePermissions": FilePermissionsStringMacro.self
    ]

    func testExpands_rwxr_xr_x() {
        assertMacroExpansion(
            """
            let perms: FilePermissions = #filePermissions("rwxr-xr-x")
            """,
            expandedSource: """
            let perms: FilePermissions = [.readUser, .writeUser, .executeUser, .readGroup, .executeGroup, .readOther, .executeOther]
            """,
            macros: macros
        )
    }

    func testExpands_withLeadingTypeAndWhitespace() {
        assertMacroExpansion(
            """
            let perms: FilePermissions = #filePermissions("-rwx r-x r-x")
            """,
            expandedSource: """
            let perms: FilePermissions = [.readUser, .writeUser, .executeUser, .readGroup, .executeGroup, .readOther, .executeOther]
            """,
            macros: macros
        )
    }

    func testExpands_setuidUppercaseS_noExec() {
        assertMacroExpansion(
            """
            let perms: FilePermissions = #filePermissions("rwSr-xr-x")
            """,
            expandedSource: """
            let perms: FilePermissions = [.setUserID, .readUser, .writeUser, .readGroup, .executeGroup, .readOther, .executeOther]
            """,
            macros: macros
        )
    }

    func testExpands_stickyUppercaseT_noExec() {
        assertMacroExpansion(
            """
            let perms: FilePermissions = #filePermissions("rwxr-xr-T")
            """,
            expandedSource: """
            let perms: FilePermissions = [.sticky, .readUser, .writeUser, .executeUser, .readGroup, .executeGroup, .readOther]
            """,
            macros: macros
        )
    }

    func testExpands_allDashes_Empty() {
        assertMacroExpansion(
            """
            let perms: FilePermissions = #filePermissions("---------")
            """,
            expandedSource: """
            let perms: FilePermissions = [] as FilePermissions
            """,
            macros: macros
        )
    }

    func testExpands_allBits_rwsrwsrwt() {
        assertMacroExpansion(
            """
            let perms: FilePermissions = #filePermissions("rwsrwsrwt")
            """,
            expandedSource: """
            let perms: FilePermissions = [.setUserID, .setGroupID, .sticky, .readUser, .writeUser, .executeUser, .readGroup, .writeGroup, .executeGroup, .readOther, .writeOther, .executeOther]
            """,
            macros: macros
        )
    }

    func testInvalid_wrongLength() {
        assertMacroExpansion(
            """
            let perms: FilePermissions = #filePermissions("rwx")
            """,
            expandedSource: """
            let perms: FilePermissions = #filePermissions("rwx")
            """,
            diagnostics: [
                .init(message: "filePermissions string must describe exactly 9 permission characters (optionally preceded by a file type), e.g. \"rwxr-xr-x\" or \"-rwxr-xr-x\"", line: 1, column: 30)
            ],
            macros: macros
        )
    }

    func testInvalid_interpolationNotAllowed() {
        assertMacroExpansion(
            """
            let perms: FilePermissions = #filePermissions("rwxr-\\(1)r-x")
            """,
            expandedSource: """
            let perms: FilePermissions = #filePermissions("rwxr-\\(1)r-x")
            """,
            diagnostics: [
                .init(message: "filePermissions string must be a simple, static string literal without interpolation", line: 1, column: 30)
            ],
            macros: macros
        )
    }

    func testInvalid_characterOutOfSet() {
        assertMacroExpansion(
            """
            let perms: FilePermissions = #filePermissions("rwxrqxr-x")
            """,
            expandedSource: """
            let perms: FilePermissions = #filePermissions("rwxrqxr-x")
            """,
            diagnostics: [
                .init(message: "invalid character at position 4 in permission string: rwxrqxr-x", line: 1, column: 30)
            ],
            macros: macros
        )
    }

    func testInvalid_invalidOtherExecutePosition() {
        assertMacroExpansion(
            """
            let perms: FilePermissions = #filePermissions("rwxr-xr-s")
            """,
            expandedSource: """
            let perms: FilePermissions = #filePermissions("rwxr-xr-s")
            """,
            diagnostics: [
                .init(message: "invalid character at position 8 in permission string: rwxr-xr-s", line: 1, column: 30)
            ],
            macros: macros
        )
    }

    func testInvalid_noArgument() {
        assertMacroExpansion(
            """
            let perms: FilePermissions = #filePermissions()
            """,
            expandedSource: """
            let perms: FilePermissions = #filePermissions()
            """,
            diagnostics: [
                .init(message: "filePermissions requires a single string literal argument, e.g. \"rwxr-xr-x\"", line: 1, column: 30)
            ],
            macros: macros
        )
    }
}
