// Calligraphy
// FilePermissions.swift
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

/// A strongly typed representation of POSIX file permission bits.
///
/// `FilePermissions` models the classic Unix permission scheme as an `OptionSet`,
/// making it easy to compose, inspect, and serialize permission bits for
/// user, group, and other, along with the special bits: set-user-ID (setuid),
/// set-group-ID (setgid), and the sticky bit.
///
/// The bit layout follows the conventional octal representation:
///
/// - Thousands place: special bits (`setuid`, `setgid`, `sticky`)
/// - Hundreds: user (owner) permissions
/// - Tens: group permissions
/// - Ones: other (world) permissions
///
/// For example, `0o755` corresponds to `rwxr-xr-x`, and `0o4755` adds `setuid`.
///
/// - Important: This type represents the requested permission bits. When creating or
///   modifying files at runtime, the effective permissions may be further restricted
///   by the process umask.
///
/// You can build values by combining the predefined flags for each permissions class:
///
/// | Class   | Flags |
/// | :------ | :----- |
/// | User    | ``FilePermissions/readUser``, ``FilePermissions/writeUser``, ``FilePermissions/executeUser`` |
/// | Group   | ``FilePermissions/readGroup``, ``FilePermissions/writeGroup``, ``FilePermissions/executeGroup`` |
/// | Other   | ``FilePermissions/readOther``, ``FilePermissions/writeOther``, ``FilePermissions/executeOther`` |
/// | Special | ``FilePermissions/setUserID``, ``FilePermissions/setGroupID``, ``FilePermissions/sticky`` |
///
/// Presents for common permissions are provided as well
///
/// - ``FilePermissions/defaultFile``: `rw-r--r--` (`0o644`)
/// - ``FilePermissions/defaultDirectory``: `rwxr-xr-x` (`0o755`),  appropriate for directories
/// - ``FilePermissions/executableFile``: `rwxr-xr-x` (`0o755`), appropriate for executables
///
/// You can also create instances of this type with string or octal literals using the built-in macros ``filePermissions(_:)-7g6n8`` or ``filePermissions(_:)-4o1io``.
public struct FilePermissions: OptionSet, Equatable, Hashable, Identifiable, Codable, CustomStringConvertible, Sendable {

    // MARK: - API

    /// User read
    public static let readUser = FilePermissions(rawValue: 0o400)

    /// User write
    public static let writeUser = FilePermissions(rawValue: 0o200)

    /// User execute
    public static let executeUser = FilePermissions(rawValue: 0o100)

    /// Read group
    public static let readGroup = FilePermissions(rawValue: 0o040)

    /// Write group
    public static let writeGroup = FilePermissions(rawValue: 0o020)

    /// Execute group
    public static let executeGroup = FilePermissions(rawValue: 0o010)

    /// Read other
    public static let readOther = FilePermissions(rawValue: 0o004)

    /// Write other
    public static let writeOther = FilePermissions(rawValue: 0o002)

    /// Execute other
    public static let executeOther = FilePermissions(rawValue: 0o001)

    /// `setuid`
    public static let setUserID = FilePermissions(rawValue: 0o4000)

    /// `setgid`
    public static let setGroupID = FilePermissions(rawValue: 0o2000)

    /// sticky bit
    public static let sticky = FilePermissions(rawValue: 0o1000)

    /// The default file permissions
    public static let defaultFile: FilePermissions = [.readUser, .writeUser, .readGroup, .readOther]

    /// The default directory permissions
    public static let defaultDirectory: FilePermissions = [.readUser, .writeUser, .executeUser, .readGroup, .executeGroup, .readOther, .executeOther]

    /// The default permissions for an executable file
    public static let executableFile: FilePermissions = [.defaultFile, .executeUser, .executeGroup, .executeOther]

    // MARK: - OptionSet

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public let rawValue: Int

    // MARK: - Identifiable

    public typealias ID = Int

    public var id: ID {
        rawValue
    }

    // MARK: - CustomStringConvertible

    public var description: String {

        func bit(
            _ read: FilePermissions,
            _ write: FilePermissions,
            _ exec: FilePermissions
        ) -> [Character] {
            [contains(read) ? "r" : "-", contains(write) ? "w" : "-", contains(exec) ? "x" : "-"]
        }

        var chars = bit(.readUser, .writeUser, .executeUser) + bit(.readGroup, .writeGroup, .executeGroup) + bit(.readOther, .writeOther, .executeOther)

        if contains(.setUserID) {
            let exec = contains(.executeUser)
            chars[2] = exec ? "s" : "S"
        }

        if contains(.setGroupID) {
            let exec = contains(.executeGroup)
            chars[5] = exec ? "s" : "S"
        }

        if contains(.sticky) {
            let exec = contains(.executeOther)
            chars[8] = exec ? "t" : "T"
        }

        return String(chars)
    }

}

/// Creates a `FilePermissions` value from an octal permission literal at compile time.
///
/// Use this macro to express Unix-style file permission
/// bits in familiar octal form and obtain a strongly-typed ``FilePermissions`` value
/// with zero runtime overhead.
///
/// You must provide an integer literal written in octal notation using the `0o`
/// prefix. The macro validates the literal and emits diagnostics at compile time
/// for invalid input.
///
/// **Special bits (thousands place)**
///
///   | Octal   | Meaning               |
///   | :------ | :-------------------- |
///   | `0o4000`| set-user-ID (setuid)  |
///   | `0o2000`| set-group-ID (setgid) |
///   | `0o1000`| sticky bit            |
///
/// **User, group, other (hundreds, tens, ones)**
///
///   | Permission | Value |
///   | :--------- | :---- |
///   | Read       | 4     |
///   | Write      | 2     |
///   | Execute    | 1     |
///
/// - Important: This macro constructs permission bits only; actual file creation or mutation may be further
///   affected by process umask at runtime.
///
/// To express permissions in string literal form instead, use ``filePermissions(_:)-4o1io``.
///
/// ## Examples
///
/// ```swift
/// // Read/write for user, read-only for group and others: rw-r--r--
/// let permsissions = #filePermissions(0o644)
///
/// // Common executable: rwxr-xr-x
/// let exec = #filePermissions(0o755)
///
/// // setuid + 755
/// let setuidExec = #filePermissions(0o4755)
/// ```
///
/// ## Validation
///
/// - The argument must be an integer literal known at compile time.
/// - The literal must use octal notation (`0o...`) and only contain digits 0–7.
/// - The value must be within the valid permission range (typically `0o0000...0o7777`).
/// - Negative values are not allowed.
///
/// - Note: The macro does not recognize legacy `0755` syntax — always use the `0o` prefix (e.g., `0o755`).
///
/// - Parameter octal: An integer literal written in octal notation (`0o...`) representing the desired permission bits, including optional special bits.
/// - Returns: A ``FilePermissions`` value equivalent to the supplied octal literal.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@freestanding(expression)
public macro filePermissions(
    _ octal: Int
) -> FilePermissions = #externalMacro(
    module: "CalligraphyCompilerPlugin",
    type: "FilePermissionsOctalMacro"
)

/// Creates a `FilePermissions` value from a symbolic Unix permission string at compile time.
///
/// Use this macro to express permissions in the familiar symbolic form (e.g., `rwxr-xr-x`)
/// and obtain a strongly-typed ``FilePermissions`` value with zero runtime overhead.
///
/// The argument must be a simple, static string literal (no interpolation). Whitespace
/// inside the string is ignored, and an optional leading file-type character is allowed
/// (e.g., `-`, `d`, `l`, `c`, `b`, `s`, `p`). The file-type character, if present,
/// is ignored for the purpose of computing permission bits.
///
/// Valid input must match the following criteria:
///
/// - Exactly 9 permission characters in user/group/other order: `u(rwx) g(rwx) o(rwx)`
/// - Optional leading file-type character (10th character): e.g., `-rwxr-xr-x`, `drwxr-xr-x`
/// - Optional whitespace anywhere in the string (it will be removed)
///
/// **Allowed characters by position**
///
/// | Class | Read | Write | Execute |
/// | :---- | :--- | :---- | :------ |
/// | User  | `r` or `-` | `w` or `-` | `x`, `-`, `s`, `S` |
/// | Group | `r` or `-` | `w` or `-` | `x`, `-`, `s`, `S` |
/// | Other | `r` or `-` | `w` or `-` | `x`, `-`, `t`, `T` |
///
/// **Special-bit semantics**
///
/// | Symbol | Position      | Meaning                          |
/// | :----- | :------------ | :------------------------------- |
/// | `s`    | user execute  | setuid + execute user            |
/// | `S`    | user execute  | setuid without execute user      |
/// | `s`    | group execute | setgid + execute group           |
/// | `S`    | group execute | setgid without execute group     |
/// | `t`    | other execute | sticky + execute other           |
/// | `T`    | other execute | sticky without execute other     |
///
/// - Important: This macro constructs permission bits only; actual file creation or mutation may be further
///   affected by process umask at runtime.
///
/// To express permissions in octal form instead, use ``filePermissions(_:)-7g6n8`` instead.
///
/// ## Examples
///
/// ```swift
/// // Read/write for user, read-only for group and others: rw-r--r--
/// let perms = #filePermissions("rw-r--r--")
///
/// // Common executable: rwxr-xr-x
/// let exec = #filePermissions("rwxr-xr-x")
///
/// // With leading file-type character (ignored): -rwxr-xr-x
/// let typed = #filePermissions("-rwxr-xr-x")
///
/// // setuid executable for user: rwSr-xr-x (uppercase S = setuid without x)
/// let setuidNoExecUser = #filePermissions("rwSr-xr-x")
///
/// // Whitespace tolerated:
/// let spaced = #filePermissions("rwx r-x r-x")
/// ```
///
/// ## Validation
///
/// The macro validates the string at compile time and emits diagnostics for invalid input:
/// - Exactly one argument is required, and it must be a simple string literal (no interpolation).
/// - After removing whitespace and an optional leading file-type character, exactly 9 characters must remain.
/// - Each position must use one of the allowed characters listed above; otherwise a position-specific error is emitted.
///
/// - Parameter literal: A static string literal describing symbolic permissions, optionally preceded by a file-type character and/or containing whitespace.
/// - Returns: A ``FilePermissions`` value equivalent to the supplied symbolic string.
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
@freestanding(expression)
public macro filePermissions(
    _ literal: String
) -> FilePermissions = #externalMacro(
    module: "CalligraphyCompilerPlugin",
    type: "FilePermissionsStringMacro"
)
