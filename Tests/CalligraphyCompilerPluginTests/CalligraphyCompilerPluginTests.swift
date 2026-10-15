// Calligraphy
// CalligraphyCompilerPluginTests.swift
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

import Testing

#if canImport(CalligraphyCompilerPlugin)
    @testable import CalligraphyCompilerPlugin
#endif

#if !canImport(SwiftSyntax604)
    import SwiftSyntaxMacroExpansion
    import SwiftSyntaxMacrosGenericTestSupport

    func assertMacroExpansion(
        _ originalSource: String,
        expandedSource: String,
        diagnostics: [DiagnosticSpec] = [],
        macroSpecs: [String: MacroSpec],
        fileID: StaticString = #fileID,
        filePath: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column
    ) {
        SwiftSyntaxMacrosGenericTestSupport.assertMacroExpansion(
            originalSource,
            expandedSource: expandedSource,
            diagnostics: diagnostics,
            macroSpecs: macroSpecs,
            failureHandler: { failure in
                Issue.record(
                    Comment(rawValue: failure.message),
                    sourceLocation: SourceLocation(
                        fileID: failure.location.fileID,
                        filePath: failure.location.filePath,
                        line: failure.location.line,
                        column: failure.location.column
                    )
                )
            },
            fileID: fileID,
            filePath: filePath,
            line: line,
            column: column
        )
    }
#endif

@Test("Compiler plugin tests")
func calligraphyCompilerPluginTests() {
    #if canImport(CalligraphyCompilerPlugin)
        let plugin = CalligraphyCompilerPlugin()
        #expect(plugin.providingMacros.count == 3)
        #expect(plugin.providingMacros[0] is FilePermissionsOctalMacro.Type)
        #expect(plugin.providingMacros[1] is FilePermissionsStringMacro.Type)
        #expect(plugin.providingMacros[2] is EntryMacro.Type)
    #else
        Issue.record("macros are only supported when running tests for the host platform")
    #endif
}
