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
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct FilePermissionsStringMacro: ExpressionMacro {

    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        // Expect exactly one string literal argument like "rwxr-xr-x".
        // Also accept optional whitespace separators (e.g. "rwx r-x r-x") and an optional leading file type char (e.g. "-rwxr-xr-x").
        guard node.arguments.count == 1 else {
            throw MacroExpansionErrorMessage("filePermissions requires a single string literal argument, e.g. \"rwxr-xr-x\"")
        }

        let stringLiteral = try node.arguments.first
            .mustExist()
            .expression
            .as(StringLiteralExprSyntax.self)
            .mustExist()

        // Ensure no interpolation and capture the raw content
        guard stringLiteral.segments.count == 1,
              let first = stringLiteral.segments.first,
              let segment = first.as(StringSegmentSyntax.self) else {
            throw MacroExpansionErrorMessage("filePermissions string must be a simple, static string literal without interpolation")
        }

        // Normalize by removing all whitespace
        let raw = segment.content.text
        var normalized = String(raw.filter { !$0.isWhitespace })

        // If there's a leading file type character, strip it (e.g., '-', 'd', 'l', 'c', 'b', 's', 'p')
        let fileTypeChars: Set<Character> = ["-", "d", "l", "c", "b", "s", "p"]
        if normalized.count == 10, let firstChar = normalized.first, fileTypeChars.contains(firstChar) {
            normalized.removeFirst()
        }

        // Validate the symbolic permission string (9 characters: u=rwx, g=rwx, o=rwx)
        guard normalized.count == 9 else {
            throw MacroExpansionErrorMessage("filePermissions string must describe exactly 9 permission characters (optionally preceded by a file type), e.g. \"rwxr-xr-x\" or \"-rwxr-xr-x\"")
        }

        // Helper to index into the string safely
        func char(at i: Int) -> Character { normalized[normalized.index(normalized.startIndex, offsetBy: i)] }

        // Validate allowed characters at each position
        let allowed: [Set<Character>] = [
            ["r", "-"], // u r
            ["w", "-"], // u w
            ["x", "-", "s", "S"], // u x or setuid variants
            ["r", "-"], // g r
            ["w", "-"], // g w
            ["x", "-", "s", "S"], // g x or setgid variants
            ["r", "-"], // o r
            ["w", "-"], // o w
            ["x", "-", "t", "T"], // o x or sticky variants
        ]

        for i in 0..<9 {
            guard allowed[i].contains(char(at: i)) else {
                throw MacroExpansionErrorMessage("invalid character at position \(i) in permission string: \(normalized)")
            }
        }

        // Build the list of FilePermissions option names based on the string
        var parts: [String] = []

        // Special bits first for readability
        let ux = char(at: 2)
        if ux == "s" || ux == "S" { parts.append(".setUserID") }

        let gx = char(at: 5)
        if gx == "s" || gx == "S" { parts.append(".setGroupID") }

        let ox = char(at: 8)
        if ox == "t" || ox == "T" { parts.append(".sticky") }

        // User bits
        if char(at: 0) == "r" { parts.append(".readUser") }
        if char(at: 1) == "w" { parts.append(".writeUser") }
        if ux == "x" || ux == "s" { parts.append(".executeUser") }

        // Group bits
        if char(at: 3) == "r" { parts.append(".readGroup") }
        if char(at: 4) == "w" { parts.append(".writeGroup") }
        if gx == "x" || gx == "s" { parts.append(".executeGroup") }

        // Other bits
        if char(at: 6) == "r" { parts.append(".readOther") }
        if char(at: 7) == "w" { parts.append(".writeOther") }
        if ox == "x" || ox == "t" { parts.append(".executeOther") }

        let arrayLiteral = if parts.isEmpty {
            "[] as FilePermissions"
        } else {
            "[" + parts.joined(separator: ", ") + "]"
        }

        return ExprSyntax(stringLiteral: arrayLiteral)
    }

}
