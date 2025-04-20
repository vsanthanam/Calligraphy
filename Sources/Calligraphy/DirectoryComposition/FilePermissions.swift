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

public struct FilePermissions: OptionSet, Sendable, Equatable, Hashable, Identifiable, CustomStringConvertible {

    public static let readUser = FilePermissions(rawValue: 0o400)
    public static let writeUser = FilePermissions(rawValue: 0o200)
    public static let executeUser = FilePermissions(rawValue: 0o100)

    public static let readGroup = FilePermissions(rawValue: 0o040)
    public static let writeGroup = FilePermissions(rawValue: 0o020)
    public static let executeGroup = FilePermissions(rawValue: 0o010)

    public static let readOther = FilePermissions(rawValue: 0o004)
    public static let writeOther = FilePermissions(rawValue: 0o002)
    public static let executeOther = FilePermissions(rawValue: 0o001)

    public static let setUserID = FilePermissions(rawValue: 0o4000)
    public static let setGroupID = FilePermissions(rawValue: 0o2000)
    public static let sticky = FilePermissions(rawValue: 0o1000)

    public static let defaultFile: FilePermissions = [.readUser, .writeUser, .readGroup, .readOther]
    public static let defaultDirectory: FilePermissions = [.readUser, .writeUser, .executeUser, .readGroup, .executeGroup, .readOther, .executeOther]

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

    public var description: String {
        var chars: [Character] = Array(symbolic)

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

    var symbolic: String {
        func bit(
            _ read: FilePermissions,
            _ write: FilePermissions,
            _ exec: FilePermissions
        ) -> String {
            [
                contains(read) ? "r" : "-",
                contains(write) ? "w" : "-",
                contains(exec) ? "x" : "-"
            ].joined()
        }

        return bit(.readUser, .writeUser, .executeUser) +
            bit(.readGroup, .writeGroup, .executeGroup) +
            bit(.readOther, .writeOther, .executeOther)
    }

}
