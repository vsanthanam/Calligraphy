// Calligraphy
// FilePermissionsStringMacro.swift
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

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

struct FilePermissionsStringMacro: ExpressionMacro {

    static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {

        let stringValue = try node.arguments.first
            .mustExist("#filePermissions macro requires a single string literal argument")
            .expression
            .as(StringLiteralExprSyntax.self)
            .mustExist("#filePermissions macro requires a single string literal argument")
            .segments.first
            .mustExist("#filePermissions macro requires a single string literal argument")
            .as(StringSegmentSyntax.self)
            .mustExist("#filePermissions macro requires a single string literal argument")
            .content.text

        guard stringValue.count == 9 else {
            throw MacroError("Permissions string must be exactly 9 characters long")
        }

        func validChars(_ index: Int) -> [Character] {
            switch index % 3 {
            case 0: ["r", "-"]
            case 1: ["w", "-"]
            case 2: ["x", "-"]
            default: fatalError()
            }
        }

        for i in 0 ..< 9 {
            let char = stringValue[stringValue.index(stringValue.startIndex, offsetBy: i)]
            if !validChars(i).contains(char) {
                throw MacroError("Invalid permissions string")
            }
        }

        var octalValue = 0

        // User permissions (first 3 chars)
        if stringValue[stringValue.startIndex] == "r" { octalValue |= 0o400 }
        if stringValue[stringValue.index(after: stringValue.startIndex)] == "w" { octalValue |= 0o200 }
        if stringValue[stringValue.index(stringValue.startIndex, offsetBy: 2)] == "x" { octalValue |= 0o100 }

        // Group permissions (middle 3 chars)
        if stringValue[stringValue.index(stringValue.startIndex, offsetBy: 3)] == "r" { octalValue |= 0o040 }
        if stringValue[stringValue.index(stringValue.startIndex, offsetBy: 4)] == "w" { octalValue |= 0o020 }
        if stringValue[stringValue.index(stringValue.startIndex, offsetBy: 5)] == "x" { octalValue |= 0o010 }

        // Other permissions (last 3 chars)
        if stringValue[stringValue.index(stringValue.startIndex, offsetBy: 6)] == "r" { octalValue |= 0o004 }
        if stringValue[stringValue.index(stringValue.startIndex, offsetBy: 7)] == "w" { octalValue |= 0o002 }
        if stringValue[stringValue.index(stringValue.startIndex, offsetBy: 8)] == "x" { octalValue |= 0o001 }

        let octalString = String(format: "%03o", octalValue)
        return "Calligraphy.FilePermissions(rawValue: 0o\(raw: octalString))"
    }
}
