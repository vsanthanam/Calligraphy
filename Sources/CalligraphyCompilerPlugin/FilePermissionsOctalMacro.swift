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

import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct FilePermissionsOctalMacro: ExpressionMacro {

    // MARK: - ExpressionMacro

    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard node.arguments.count == 1 else {
            throw MacroExpansionErrorMessage("One")
        }

        let literal = try node.arguments.first
            .mustExist()
            .expression
            .as(IntegerLiteralExprSyntax.self)
            .mustExist()

        let str = literal.trimmedDescription

        func isValidOctalLiteral(_ octal: String) -> Bool {
            guard octal.count >= 3 else { return false }
            guard octal.hasPrefix("0o") || octal.hasPrefix("0O") else { return false }
            let digits = octal.dropFirst(2)
            guard !digits.isEmpty else { return false }
            return digits.allSatisfy { ch in
                (ch >= "0" && ch <= "7") || ch == "_"
            }
        }

        guard isValidOctalLiteral(str) else {
            throw MacroExpansionErrorMessage("filePermissions requires an octal integer literal")
        }

        // Parse octal to integer value (remove underscores)
        let cleaned = str.replacingOccurrences(of: "_", with: "")
        let digits = cleaned.dropFirst(2) // drop 0o/0O
        guard let value = Int(digits, radix: 8) else {
            throw MacroExpansionErrorMessage("filePermissions: could not parse octal literal \(str)")
        }

        // Map of bits to option case names, kept in a stable, readable order
        let mapping: [(Int, String)] = [
            (0o4000, ".setUserID"),
            (0o2000, ".setGroupID"),
            (0o1000, ".sticky"),
            (0o0400, ".readUser"),
            (0o0200, ".writeUser"),
            (0o0100, ".executeUser"),
            (0o0040, ".readGroup"),
            (0o0020, ".writeGroup"),
            (0o0010, ".executeGroup"),
            (0o0004, ".readOther"),
            (0o0002, ".writeOther"),
            (0o0001, ".executeOther"),
        ]

        var parts: [String] = []
        for (mask, name) in mapping {
            if (value & mask) != 0 { parts.append(name) }
        }

        let arrayLiteral = if parts.isEmpty {
            "[] as FilePermissions" // make the type clear when empty
        } else {
            "[" + parts.joined(separator: ", ") + "]"
        }

        return ExprSyntax(stringLiteral: arrayLiteral)
    }

}
