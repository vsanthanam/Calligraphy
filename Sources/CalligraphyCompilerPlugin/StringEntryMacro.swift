// Calligraphy
// StringEntryMacro.swift
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
import SwiftSyntaxMacros

public struct StringEntryMacro: AccessorMacro, PeerMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        let binding = try binding(from: declaration)
        let name = try identifier(from: binding).text
        let keyName = "__Key_\(name)"
        return [
            """
            get { self[\(raw: keyName).self] }
            """,
            """
            set { self[\(raw: keyName).self] = newValue }
            """
        ]
    }

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let binding = try binding(from: declaration)
        let name = try identifier(from: binding).text
        let typeAnnotation = try binding.typeAnnotation
            .mustExist("@StringEntry requires an explicit type annotation")
            .type
        let initializer = try binding.initializer
            .mustExist("@StringEntry requires an initial value")
            .value
        let keyName = "__Key_\(name)"
        return [
            """
            private struct \(raw: keyName): StringEnvironmentKey {
                static let defaultValue: \(typeAnnotation.trimmed) = \(initializer.trimmed)
            }
            """
        ]
    }

    private static func binding(
        from decl: some DeclSyntaxProtocol
    ) throws -> PatternBindingSyntax {
        try decl.as(VariableDeclSyntax.self)
            .mustExist("@StringEntry must be applied to a variable declaration")
            .bindings.first
            .mustExist("@StringEntry requires a single binding")
    }

    private static func identifier(
        from binding: PatternBindingSyntax
    ) throws -> TokenSyntax {
        try binding.pattern.as(IdentifierPatternSyntax.self)
            .mustExist("@StringEntry requires an identifier pattern")
            .identifier
    }

}
