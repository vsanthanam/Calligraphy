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

//
//  File 2.swift
//  Calligraphy
//
//  Created by Varun Santhanam on 4/12/25.
//

/// A type representing file permissions
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
public struct FilePermissions: OptionSet, Equatable, Hashable, Sendable, CustomStringConvertible {

    // MARK: - API

    /// User read permission (`r--------`)
    public static let readUser = FilePermissions(rawValue: 0o400)

    /// User write permission (`-w-------`)
    public static let writeUser = FilePermissions(rawValue: 0o200)

    /// User execute permission (`--x------`)
    public static let executeUser = FilePermissions(rawValue: 0o100)

    /// Group read permission (`---r-----`)
    public static let readGroup = FilePermissions(rawValue: 0o040)

    /// Group write permission (`----w----`)
    public static let writeGroup = FilePermissions(rawValue: 0o020)

    /// Group execute permission (`-----x---`)
    public static let executeGroup = FilePermissions(rawValue: 0o010)

    /// Other read permission (`------r--`)
    public static let readOther = FilePermissions(rawValue: 0o004)

    /// Other write permission (`-------w-`)
    public static let writeOther = FilePermissions(rawValue: 0o002)

    /// Other execute permission (`--------x`)
    public static let executeOther = FilePermissions(rawValue: 0o001)
    
    /// All read permissions (`r--r--r--`)
    public static let readAll: FilePermissions = [
        .readUser,
        .readGroup,
        .readOther
    ]
    
    /// All write permissions (`-w--w--w-`)
    public static let writeAll: FilePermissions = [
        .writeUser,
        .writeGroup,
        .writeOther
    ]
    
    /// All execute permissions (`--x--x--x`)
    public static let executeAll: FilePermissions = [
        .executeUser,
        .executeGroup,
        .executeOther
    ]
    
    /// All user permissions (`rwx------`)
    public static let userAll: FilePermissions = [
        .readUser,
        .writeUser,
        .executeUser
    ]
    
    /// All group permissions (`---rwx---`)
    public static let groupAll: FilePermissions = [
        .readGroup,
        .writeGroup,
        .executeGroup
    ]
    
    /// All other permissions (`------rwx`)
    public static let otherAll: FilePermissions = [
        .readOther,
        .writeOther,
        .executeOther
    ]
    
    /// Default permissions (`rw-r--r--`)
    public static let `default`: FilePermissions = [
        .readUser,
        .writeUser,
        .readGroup,
        .readOther
    ]

    /// Default executable permissions (`rwxr-xr-x`)
    public static let defaultExecutable: FilePermissions = [
        .default,
        .executeAll
    ]

    /// All permissions (`rwxrwxrwx`)
    public static let all: FilePermissions = [
        .userAll,
        .groupAll,
        .otherAll
    ]

    /// No permissions (`---------`)
    public static let none: FilePermissions = []

    // MARK: - OptionSet

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public let rawValue: Int

    // MARK: - CustomStringConvertible

    public var description: String {
        String.build {
            Line {
                Read(contains(.readUser))
                Write(contains(.writeUser))
                Execute(contains(.executeUser))
                Read(contains(.readGroup))
                Write(contains(.writeGroup))
                Execute(contains(.executeGroup))
                Read(contains(.readOther))
                Write(contains(.writeOther))
                Execute(contains(.executeOther))
            }
        }
    }

    private struct Read: StringComponent {

        init(_ hasPermission: Bool) {
            self.hasPermission = hasPermission
        }

        var body: some StringComponent {
            Permission(hasPermission) {
                "r"
            }
        }

        private let hasPermission: Bool

    }

    private struct Write: StringComponent {

        init(_ hasPermission: Bool) {
            self.hasPermission = hasPermission
        }

        var body: some StringComponent {
            Permission(hasPermission) {
                "w"
            }
        }

        private let hasPermission: Bool

    }

    private struct Execute: StringComponent {

        init(_ hasPermission: Bool) {
            self.hasPermission = hasPermission
        }

        var body: some StringComponent {
            Permission(hasPermission) {
                "r"
            }
        }

        private let hasPermission: Bool

    }

    private struct Permission<T>: StringComponent where T: StringComponent {

        init(
            _ hasPermission: Bool,
            @StringBuilder value: () -> T
        ) {
            self.hasPermission = hasPermission
            self.value = value()
        }

        var body: some StringComponent {
            if hasPermission {
                value
            } else {
                "-"
            }
        }

        private let hasPermission: Bool
        private let value: T
    }

}
