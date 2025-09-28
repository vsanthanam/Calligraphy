// Calligraphy
// FilePermissionsTests.swift
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
import Foundation
import Testing

@Suite("File Permissions Tests", .tags(.directoryComposition))
struct FilePermissionsTests {

    @Test("Octal Macro - 0o644")
    func octal0644() {
        let perms = #filePermissions(0o644)
        #expect(perms == .defaultFile)
        #expect(perms.rawValue == 0o644)
        #expect(perms.description == "rw-r--r--")
    }

    @Test("Octal Macro - 0o755")
    func octal0755() {
        let perms = #filePermissions(0o755)
        #expect(perms == .executableFile)
        #expect(perms == .defaultDirectory)
        #expect(perms.rawValue == 0o755)
        #expect(perms.description == "rwxr-xr-x")
    }

    @Test("Octal Macro - Special Bits (0o7777)")
    func octal07777() {
        let perms = #filePermissions(0o7777)
        #expect(perms.contains(.setUserID))
        #expect(perms.contains(.setGroupID))
        #expect(perms.contains(.sticky))
        #expect(perms.description == "rwsrwsrwt")
    }

    @Test("Octal Macro - Underscores Allowed")
    func octalWithUnderscores() {
        let perms = #filePermissions(0o755)
        #expect(perms.rawValue == 0o755)
        #expect(perms.description == "rwxr-xr-x")
    }

    @Test("Octal Macro - Empty (0o000)")
    func octal0000() {
        let perms = #filePermissions(0o000)
        #expect(perms.rawValue == 0)
        #expect(perms.description == "---------")
    }

    @Test("String Macro - rwxr-xr-x")
    func string_rwxr_xr_x() {
        let perms = #filePermissions("rwxr-xr-x")
        #expect(perms.rawValue == 0o755)
        #expect(perms.description == "rwxr-xr-x")
    }

    @Test("String Macro - With Leading Type and Whitespace")
    func string_withTypeAndWhitespace() {
        let perms = #filePermissions("-rwx r-x r-x")
        #expect(perms.rawValue == 0o755)
        #expect(perms.description == "rwxr-xr-x")
    }

    @Test("String Macro - setuid Without Exec (S)")
    func string_setuidNoExec() {
        let perms = #filePermissions("rwSr-xr-x")
        #expect(perms.contains(.setUserID))
        #expect(!perms.contains(.executeUser))
        #expect(perms.description == "rwSr-xr-x")
    }

    @Test("String Macro - sticky Without Exec (T)")
    func string_stickyNoExec() {
        let perms = #filePermissions("rwxr-xr-T")
        #expect(perms.contains(.sticky))
        #expect(!perms.contains(.executeOther))
        #expect(perms.description == "rwxr-xr-T")
    }

    @Test("Macro Parity - String == Octal (755)")
    func macroParity_755() {
        let a = #filePermissions(0o755)
        let b = #filePermissions("rwxr-xr-x")
        #expect(a == b)
        #expect(a.rawValue == b.rawValue)
    }

    @Test("defaultFile (0o644)")
    func preset_defaultFile() {
        let perms: FilePermissions = [.readUser, .writeUser, .readGroup, .readOther]
        #expect(perms == .defaultFile)
        #expect(perms.rawValue == 0o644)
        #expect(perms.description == "rw-r--r--")
    }

    @Test("defaultDirectory/executableFile (0o755)")
    func preset_defaultDirectory_executableFile() {
        let perms: FilePermissions = [.readUser, .writeUser, .executeUser, .readGroup, .executeGroup, .readOther, .executeOther]
        #expect(perms == .defaultDirectory)
        #expect(perms == .executableFile)
        #expect(perms.rawValue == 0o755)
        #expect(perms.description == "rwxr-xr-x")
    }

    @Test("Identifiable Support")
    func identifiableID() {
        let perms = FilePermissions.defaultDirectory
        #expect(perms.id == perms.rawValue)
    }

    @Test("Description - Special Bits Uppercase Forms (S/T)")
    func description_specialBitsUppercase() {
        var perms: FilePermissions = [.readUser, .writeUser, .readGroup, .executeGroup, .readOther, .executeOther, .setUserID, .sticky]
        perms.remove(.executeOther)
        #expect(perms.description == "rwSr-xr-T")
    }

}
