//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//

import Calligraphy

/// Creates a `FilePermissions` instance from a Unix-style permissions string literal.
///
/// You can use any properly formatted unix-style string permissions string literal value.
/// For example, `rwxr-xr--` represents read, write, and execute for the user, read and execute for the group, and read-only for others.
///
/// You can use the macro like this:
///
/// ```swift
/// let permissions = #filePermissions("rwxr-xr--")
/// ```
///
/// - Important: The string must be exactly 9 characters long and can only contain 'r', 'w', 'x', or '-'.
/// - Parameter string: The permissions string to convert.
/// - Returns: A `FilePermissions` instance with the corresponding permissions.
@freestanding(expression)
public macro filePermissions(
    _ string: String
) -> FilePermissions = #externalMacro(module: "CalligraphyCompilerPlugin", type: "FilePermissionsMacro")
