import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// A macro that creates a `FilePermissions` instance from a string literal.
///
/// The string must be a valid Unix-style permissions string (e.g., "rwxr-xr--").
/// The macro will fail to compile if the string is invalid.
public struct FilePermissionsMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard let stringLiteral = node.arguments.first?.expression.as(StringLiteralExprSyntax.self),
              let stringValue = stringLiteral.segments.first?.as(StringSegmentSyntax.self)?.content.text else {
            throw MacroError("FilePermissions macro requires a string literal argument")
        }
        
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
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    var description: String { message }
}

@main
struct CalligraphyCompilerPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        FilePermissionsMacro.self
    ]
} 
