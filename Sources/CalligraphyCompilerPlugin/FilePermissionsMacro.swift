//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//

import SwiftSyntax
import SwiftSyntaxMacros

struct FilePermissionsMacro: ExpressionMacro {
   
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
        
//        guard let stringLiteral = node.arguments.first?.expression.as(StringLiteralExprSyntax.self),
//              let stringValue = stringLiteral.segments.first?.as(StringSegmentSyntax.self)?.content.text else {
//            throw MacroError("FilePermissions macro requires a string literal argument")
//        }

        // Validate the string format
        guard stringValue.count == 9 else {
            throw MacroError("Permissions string must be exactly 9 characters long")
        }

        let validChars: Set<Character> = ["r", "w", "x", "-"]
        guard stringValue.allSatisfy(validChars.contains) else {
            throw MacroError("Permissions string can only contain 'r', 'w', 'x', or '-'")
        }

        // Convert to octal
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

        return "FilePermissions(rawValue: \(raw: octalValue))"
    }
}

struct MacroError: Error, CustomStringConvertible {
    
    init(_ message: String) {
        self.message = message
    }
    
    private let message: String
    
    var description: String { message }
    
}

extension Optional {
    
    func mustExist(_ message: @autoclosure () -> String) throws -> Wrapped {
        switch self {
        case .none:
            throw MacroError(message())
        case let .some(wrapped):
            wrapped
        }
    }
    
}
