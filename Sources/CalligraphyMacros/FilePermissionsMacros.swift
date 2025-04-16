// Calligraphy
// Macros.swift
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

import Calligraphy

/// Create a `FilePermissions` instance from a Unix-style permissions string literal.
///
/// You can use any properly formatted unix-style string permissions string literal value. Any other values will result in a compile-time failure.
/// For example, `rwxr-xr--` represents read, write, and execute for the user, read and execute for the group, and read-only for others.
///
/// You can use the macro like this:
///
/// ```swift
/// let permissions = #filePermissions("rwxr-xr--")
/// ```
///
/// - Important: The string must be exactly 9 characters long and can only contain `'r'`, `'w'`, `'x'`, or `'-'`, with `'r'` appearing only in indexes `0`, `3`, and `6`, `'w'` appearing only in indexes `1`, `4`, and `7`, and `'x'` appearing only in indexes `2`, `5`, and `8`. `'-'` may appear at any index.
/// - Parameter string: The permissions string to convert.
/// - Returns: A `FilePermissions` instance with the corresponding permissions.
@freestanding(expression)
public macro filePermissions(
    _ string: String
) -> FilePermissions = #externalMacro(
    module: "CalligraphyCompilerPlugin",
    type: "FilePermissionsStringMacro"
)

/// Create a `FilePermissions` instance from an octal literal
///
/// You can use any octal from compile-time octal literal `0o000` to `0o777`. Any other values will result in a compile-time failure.
///
/// You can use the macro like this:
///
/// ```swift
/// let prermissions = #filePermissions(0o400)
/// ```
@freestanding(expression)
public macro filePermissions(
    _ int: Int
) -> FilePermissions = #externalMacro(
    module: "CalligraphyCompilerPlugin",
    type: "FilePermissionsOctalMacro"
)
