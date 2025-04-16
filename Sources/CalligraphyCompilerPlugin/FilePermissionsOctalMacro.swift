// Calligraphy
// FilePermissionsOctalMacro.swift
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

import SwiftSyntax
import SwiftSyntaxMacros

struct FilePermissionsOctalMacro: ExpressionMacro {

    static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        let stringValue = try node.arguments.first
            .mustExist("#filePermissions macro requires a single octal literal argument")
            .expression
            .as(IntegerLiteralExprSyntax.self)
            .mustExist("#filePermissions macro requires a single octal literal argument")
            .literal.text

        guard stringValue.hasPrefix("0o") else {
            throw MacroError("#filePermissions macro requires a single octal literal argument")
        }

        let octalPart = String(stringValue.dropFirst(2))
        guard let intValue = Int(octalPart, radix: 8) else {
            throw MacroError("#filePermissions macro requires a single octal literal argument")
        }

        guard intValue >= 0, intValue < 512 else {
            throw MacroError("#filePermissions must be between 0o000 and 0o777")
        }

        return "Calligraphy.FilePermissions(rawValue: \(raw: stringValue))"
    }
}
