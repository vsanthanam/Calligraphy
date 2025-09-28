// Calligraphy
// FilePermissionsOctalMacroTests.swift
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

final class FilePermissionsOctalMacroTests: XCTestCase {

    private let macros: [String: any Macro.Type] = [
        "filePermissions": FilePermissionsOctalMacro.self
    ]

    func testExpands0644() {
        assertMacroExpansion(
            """
            let perms: FilePermissions = #filePermissions(0o644)
            """,
            expandedSource: """
            let perms: FilePermissions = [.readUser, .writeUser, .readGroup, .readOther]
            """,
            macros: macros
        )
    }

    func testExpands0755() {
        assertMacroExpansion(
            """
            let perms: FilePermissions = #filePermissions(0o755)
            """,
            expandedSource: """
            let perms: FilePermissions = [.readUser, .writeUser, .executeUser, .readGroup, .executeGroup, .readOther, .executeOther]
            """,
            macros: macros
        )
    }

    func testExpands07777_AllBits() {
        assertMacroExpansion(
            """
            let perms: FilePermissions = #filePermissions(0o7777)
            """,
            expandedSource: """
            let perms: FilePermissions = [.setUserID, .setGroupID, .sticky, .readUser, .writeUser, .executeUser, .readGroup, .writeGroup, .executeGroup, .readOther, .writeOther, .executeOther]
            """,
            macros: macros
        )
    }

    func testExpands0000_Empty() {
        assertMacroExpansion(
            """
            let perms: FilePermissions = #filePermissions(0o000)
            """,
            expandedSource: """
            let perms: FilePermissions = [] as FilePermissions
            """,
            macros: macros
        )
    }

    func testUnderscoresAllowed() {
        assertMacroExpansion(
            """
            let perms: FilePermissions = #filePermissions(0o7_5_5)
            """,
            expandedSource: """
            let perms: FilePermissions = [.readUser, .writeUser, .executeUser, .readGroup, .executeGroup, .readOther, .executeOther]
            """,
            macros: macros
        )
    }

    func testInvalidLiteral_Diagnostic() {
        assertMacroExpansion(
            """
            let perms: FilePermissions = #filePermissions(755)
            """,
            expandedSource: """
            let perms: FilePermissions = #filePermissions(755)
            """,
            diagnostics: [
                .init(message: "filePermissions requires an octal integer literal", line: 1, column: 30)
            ],
            macros: macros
        )
    }

}
