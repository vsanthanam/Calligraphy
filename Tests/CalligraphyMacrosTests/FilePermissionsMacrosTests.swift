// Calligraphy
// FilePermissionsMacroTests.swift
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
@testable import CalligraphyMacros
import Testing
import Foundation

@Suite
struct FilePermissionsMacroTests {

    @Test("Macro evaluate ---------")
    func permission_combination_000() {
        let macro = #filePermissions("---------")
        let expected = FilePermissions.none
        #expect(macro == expected)
    }

    @Test("Macro evaluate --------x")
    func permission_combination_001() {
        let macro = #filePermissions("--------x")
        let expected = FilePermissions.executeOther
        #expect(macro == expected)
    }

    @Test("Macro evaluate -------w-")
    func permission_combination_002() {
        let macro = #filePermissions("-------w-")
        let expected = FilePermissions.writeOther
        #expect(macro == expected)
    }

    @Test("Macro evaluate -------wx")
    func permission_combination_003() {
        let macro = #filePermissions("-------wx")
        let expected = FilePermissions([.writeOther, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ------r--")
    func permission_combination_004() {
        let macro = #filePermissions("------r--")
        let expected = FilePermissions.readOther
        #expect(macro == expected)
    }

    @Test("Macro evaluate ------r-x")
    func permission_combination_005() {
        let macro = #filePermissions("------r-x")
        let expected = FilePermissions([.readOther, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ------rw-")
    func permission_combination_006() {
        let macro = #filePermissions("------rw-")
        let expected = FilePermissions([.readOther, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ------rwx")
    func permission_combination_007() {
        let macro = #filePermissions("------rwx")
        let expected = FilePermissions.otherAll
        #expect(macro == expected)
    }

    @Test("Macro evaluate -----x---")
    func permission_combination_008() {
        let macro = #filePermissions("-----x---")
        let expected = FilePermissions.executeGroup
        #expect(macro == expected)
    }

    @Test("Macro evaluate -----x--x")
    func permission_combination_009() {
        let macro = #filePermissions("-----x--x")
        let expected = FilePermissions([.executeGroup, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate -----x-w-")
    func permission_combination_010() {
        let macro = #filePermissions("-----x-w-")
        let expected = FilePermissions([.executeGroup, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate -----x-wx")
    func permission_combination_011() {
        let macro = #filePermissions("-----x-wx")
        let expected = FilePermissions([.executeGroup, .writeOther, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate -----xr--")
    func permission_combination_012() {
        let macro = #filePermissions("-----xr--")
        let expected = FilePermissions([.executeGroup, .readOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate -----xr-x")
    func permission_combination_013() {
        let macro = #filePermissions("-----xr-x")
        let expected = FilePermissions([.executeGroup, .readOther, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate -----xrw-")
    func permission_combination_014() {
        let macro = #filePermissions("-----xrw-")
        let expected = FilePermissions([.executeGroup, .readOther, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate -----xrwx")
    func permission_combination_015() {
        let macro = #filePermissions("-----xrwx")
        let expected = FilePermissions([.executeGroup, .otherAll])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ----w----")
    func permission_combination_016() {
        let macro = #filePermissions("----w----")
        let expected = FilePermissions.writeGroup
        #expect(macro == expected)
    }

    @Test("Macro evaluate ----w---x")
    func permission_combination_017() {
        let macro = #filePermissions("----w---x")
        let expected = FilePermissions([.writeGroup, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ----w--w-")
    func permission_combination_018() {
        let macro = #filePermissions("----w--w-")
        let expected = FilePermissions([.writeGroup, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ----w--wx")
    func permission_combination_019() {
        let macro = #filePermissions("----w--wx")
        let expected = FilePermissions([.writeGroup, .writeOther, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ----w-r--")
    func permission_combination_020() {
        let macro = #filePermissions("----w-r--")
        let expected = FilePermissions([.writeGroup, .readOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ----w-r-x")
    func permission_combination_021() {
        let macro = #filePermissions("----w-r-x")
        let expected = FilePermissions([.writeGroup, .readOther, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ----w-rw-")
    func permission_combination_022() {
        let macro = #filePermissions("----w-rw-")
        let expected = FilePermissions([.writeGroup, .readOther, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ----w-rwx")
    func permission_combination_023() {
        let macro = #filePermissions("----w-rwx")
        let expected = FilePermissions([.writeGroup, .otherAll])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ----wx---")
    func permission_combination_024() {
        let macro = #filePermissions("----wx---")
        let expected = FilePermissions([.writeGroup, .executeGroup])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ----wx--x")
    func permission_combination_025() {
        let macro = #filePermissions("----wx--x")
        let expected = FilePermissions([.writeGroup, .executeGroup, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ----wx-w-")
    func permission_combination_026() {
        let macro = #filePermissions("----wx-w-")
        let expected = FilePermissions([.writeGroup, .executeGroup, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ----wx-wx")
    func permission_combination_027() {
        let macro = #filePermissions("----wx-wx")
        let expected = FilePermissions([.writeGroup, .executeGroup, .writeOther, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ----wxr--")
    func permission_combination_028() {
        let macro = #filePermissions("----wxr--")
        let expected = FilePermissions([.writeGroup, .executeGroup, .readOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ----wxr-x")
    func permission_combination_029() {
        let macro = #filePermissions("----wxr-x")
        let expected = FilePermissions([.writeGroup, .executeGroup, .readOther, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ----wxrw-")
    func permission_combination_030() {
        let macro = #filePermissions("----wxrw-")
        let expected = FilePermissions([.writeGroup, .executeGroup, .readOther, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ----wxrwx")
    func permission_combination_031() {
        let macro = #filePermissions("----wxrwx")
        let expected = FilePermissions([.writeGroup, .executeGroup, .otherAll])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---r-----")
    func permission_combination_032() {
        let macro = #filePermissions("---r-----")
        let expected = FilePermissions.readGroup
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---r----x")
    func permission_combination_033() {
        let macro = #filePermissions("---r----x")
        let expected = FilePermissions([.readGroup, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---r---w-")
    func permission_combination_034() {
        let macro = #filePermissions("---r---w-")
        let expected = FilePermissions([.readGroup, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---r---wx")
    func permission_combination_035() {
        let macro = #filePermissions("---r---wx")
        let expected = FilePermissions([.readGroup, .writeOther, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---r--r--")
    func permission_combination_036() {
        let macro = #filePermissions("---r--r--")
        let expected = FilePermissions([.readGroup, .readOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---r--r-x")
    func permission_combination_037() {
        let macro = #filePermissions("---r--r-x")
        let expected = FilePermissions([.readGroup, .readOther, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---r--rw-")
    func permission_combination_038() {
        let macro = #filePermissions("---r--rw-")
        let expected = FilePermissions([.readGroup, .readOther, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---r--rwx")
    func permission_combination_039() {
        let macro = #filePermissions("---r--rwx")
        let expected = FilePermissions([.readGroup, .otherAll])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---r-x---")
    func permission_combination_040() {
        let macro = #filePermissions("---r-x---")
        let expected = FilePermissions([.readGroup, .executeGroup])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---r-x--x")
    func permission_combination_041() {
        let macro = #filePermissions("---r-x--x")
        let expected = FilePermissions([.readGroup, .executeGroup, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---r-x-w-")
    func permission_combination_042() {
        let macro = #filePermissions("---r-x-w-")
        let expected = FilePermissions([.readGroup, .executeGroup, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---r-x-wx")
    func permission_combination_043() {
        let macro = #filePermissions("---r-x-wx")
        let expected = FilePermissions([.readGroup, .executeGroup, .writeOther, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---r-xr--")
    func permission_combination_044() {
        let macro = #filePermissions("---r-xr--")
        let expected = FilePermissions([.readGroup, .executeGroup, .readOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---r-xr-x")
    func permission_combination_045() {
        let macro = #filePermissions("---r-xr-x")
        let expected = FilePermissions([.readGroup, .executeGroup, .readOther, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---r-xrw-")
    func permission_combination_046() {
        let macro = #filePermissions("---r-xrw-")
        let expected = FilePermissions([.readGroup, .executeGroup, .readOther, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---r-xrwx")
    func permission_combination_047() {
        let macro = #filePermissions("---r-xrwx")
        let expected = FilePermissions([.readGroup, .executeGroup, .otherAll])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---rw----")
    func permission_combination_048() {
        let macro = #filePermissions("---rw----")
        let expected = FilePermissions([.readGroup, .writeGroup])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---rw---x")
    func permission_combination_049() {
        let macro = #filePermissions("---rw---x")
        let expected = FilePermissions([.readGroup, .writeGroup, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---rw--w-")
    func permission_combination_050() {
        let macro = #filePermissions("---rw--w-")
        let expected = FilePermissions([.readGroup, .writeGroup, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---rw--wx")
    func permission_combination_051() {
        let macro = #filePermissions("---rw--wx")
        let expected = FilePermissions([.readGroup, .writeGroup, .writeOther, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---rw-r--")
    func permission_combination_052() {
        let macro = #filePermissions("---rw-r--")
        let expected = FilePermissions([.readGroup, .writeGroup, .readOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---rw-r-x")
    func permission_combination_053() {
        let macro = #filePermissions("---rw-r-x")
        let expected = FilePermissions([.readGroup, .writeGroup, .readOther, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---rw-rw-")
    func permission_combination_054() {
        let macro = #filePermissions("---rw-rw-")
        let expected = FilePermissions([.readGroup, .writeGroup, .readOther, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---rw-rwx")
    func permission_combination_055() {
        let macro = #filePermissions("---rw-rwx")
        let expected = FilePermissions([.readGroup, .writeGroup, .otherAll])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---rwx---")
    func permission_combination_056() {
        let macro = #filePermissions("---rwx---")
        let expected = FilePermissions.groupAll
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---rwx--x")
    func permission_combination_057() {
        let macro = #filePermissions("---rwx--x")
        let expected = FilePermissions([.groupAll, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---rwx-w-")
    func permission_combination_058() {
        let macro = #filePermissions("---rwx-w-")
        let expected = FilePermissions([.groupAll, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---rwx-wx")
    func permission_combination_059() {
        let macro = #filePermissions("---rwx-wx")
        let expected = FilePermissions([.groupAll, .writeOther, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---rwxr--")
    func permission_combination_060() {
        let macro = #filePermissions("---rwxr--")
        let expected = FilePermissions([.groupAll, .readOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---rwxr-x")
    func permission_combination_061() {
        let macro = #filePermissions("---rwxr-x")
        let expected = FilePermissions([.groupAll, .readOther, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---rwxrw-")
    func permission_combination_062() {
        let macro = #filePermissions("---rwxrw-")
        let expected = FilePermissions([.groupAll, .readOther, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate ---rwxrwx")
    func permission_combination_063() {
        let macro = #filePermissions("---rwxrwx")
        let expected = FilePermissions([.groupAll, .otherAll])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x------")
    func permission_combination_064() {
        let macro = #filePermissions("--x------")
        let expected = FilePermissions.executeUser
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x-----x")
    func permission_combination_065() {
        let macro = #filePermissions("--x-----x")
        let expected = FilePermissions([.executeUser, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x----w-")
    func permission_combination_066() {
        let macro = #filePermissions("--x----w-")
        let expected = FilePermissions([.executeUser, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x----wx")
    func permission_combination_067() {
        let macro = #filePermissions("--x----wx")
        let expected = FilePermissions([.executeUser, .writeOther, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x---r--")
    func permission_combination_068() {
        let macro = #filePermissions("--x---r--")
        let expected = FilePermissions([.executeUser, .readOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x---r-x")
    func permission_combination_069() {
        let macro = #filePermissions("--x---r-x")
        let expected = FilePermissions([.executeUser, .readOther, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x---rw-")
    func permission_combination_070() {
        let macro = #filePermissions("--x---rw-")
        let expected = FilePermissions([.executeUser, .readOther, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x---rwx")
    func permission_combination_071() {
        let macro = #filePermissions("--x---rwx")
        let expected = FilePermissions([.executeUser, .otherAll])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x--x---")
    func permission_combination_072() {
        let macro = #filePermissions("--x--x---")
        let expected = FilePermissions([.executeUser, .executeGroup])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x--x--x")
    func permission_combination_073() {
        let macro = #filePermissions("--x--x--x")
        let expected = FilePermissions.executeAll
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x--x-w-")
    func permission_combination_074() {
        let macro = #filePermissions("--x--x-w-")
        let expected = FilePermissions([.executeUser, .executeGroup, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x--x-wx")
    func permission_combination_075() {
        let macro = #filePermissions("--x--x-wx")
        let expected = FilePermissions([.executeAll, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x--xr--")
    func permission_combination_076() {
        let macro = #filePermissions("--x--xr--")
        let expected = FilePermissions([.executeUser, .executeGroup, .readOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x--xr-x")
    func permission_combination_077() {
        let macro = #filePermissions("--x--xr-x")
        let expected = FilePermissions([.executeAll, .readOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x--xrw-")
    func permission_combination_078() {
        let macro = #filePermissions("--x--xrw-")
        let expected = FilePermissions([.executeUser, .executeGroup, .readOther, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x--xrwx")
    func permission_combination_079() {
        let macro = #filePermissions("--x--xrwx")
        let expected = FilePermissions([.executeUser, .executeGroup, .otherAll])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x-w----")
    func permission_combination_080() {
        let macro = #filePermissions("--x-w----")
        let expected = FilePermissions([.executeUser, .writeGroup])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x-w---x")
    func permission_combination_081() {
        let macro = #filePermissions("--x-w---x")
        let expected = FilePermissions([.executeUser, .writeGroup, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x-w--w-")
    func permission_combination_082() {
        let macro = #filePermissions("--x-w--w-")
        let expected = FilePermissions([.executeUser, .writeGroup, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x-w--wx")
    func permission_combination_083() {
        let macro = #filePermissions("--x-w--wx")
        let expected = FilePermissions([.executeUser, .writeGroup, .writeOther, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x-w-r--")
    func permission_combination_084() {
        let macro = #filePermissions("--x-w-r--")
        let expected = FilePermissions([.executeUser, .writeGroup, .readOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x-w-r-x")
    func permission_combination_085() {
        let macro = #filePermissions("--x-w-r-x")
        let expected = FilePermissions([.executeUser, .writeGroup, .readOther, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x-w-rw-")
    func permission_combination_086() {
        let macro = #filePermissions("--x-w-rw-")
        let expected = FilePermissions([.executeUser, .writeGroup, .readOther, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x-w-rwx")
    func permission_combination_087() {
        let macro = #filePermissions("--x-w-rwx")
        let expected = FilePermissions([.executeUser, .writeGroup, .otherAll])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x-wx---")
    func permission_combination_088() {
        let macro = #filePermissions("--x-wx---")
        let expected = FilePermissions([.executeUser, .writeGroup, .executeGroup])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x-wx--x")
    func permission_combination_089() {
        let macro = #filePermissions("--x-wx--x")
        let expected = FilePermissions([.executeUser, .writeGroup, .executeGroup, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x-wx-w-")
    func permission_combination_090() {
        let macro = #filePermissions("--x-wx-w-")
        let expected = FilePermissions([.executeUser, .writeGroup, .executeGroup, .writeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x-wx-wx")
    func permission_combination_091() {
        let macro = #filePermissions("--x-wx-wx")
        let expected = FilePermissions([.writeGroup, .writeOther, .executeAll])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x-wxr--")
    func permission_combination_092() {
        let macro = #filePermissions("--x-wxr--")
        let expected = FilePermissions([.executeUser, .writeGroup, .executeGroup, .readOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x-wxr-x")
    func permission_combination_093() {
        let macro = #filePermissions("--x-wxr-x")
        let expected = FilePermissions([.executeUser, .writeGroup, .executeGroup, .readOther, .executeOther])
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x-wxrw-")
    func permission_combination_094() {
        let macro = #filePermissions("--x-wxrw-")
        let expected = FilePermissions(rawValue: 0o136)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --x-wxrwx")
    func permission_combination_095() {
        let macro = #filePermissions("--x-wxrwx")
        let expected = FilePermissions(rawValue: 0o137)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xr-----")
    func permission_combination_096() {
        let macro = #filePermissions("--xr-----")
        let expected = FilePermissions(rawValue: 0o140)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xr----x")
    func permission_combination_097() {
        let macro = #filePermissions("--xr----x")
        let expected = FilePermissions(rawValue: 0o141)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xr---w-")
    func permission_combination_098() {
        let macro = #filePermissions("--xr---w-")
        let expected = FilePermissions(rawValue: 0o142)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xr---wx")
    func permission_combination_099() {
        let macro = #filePermissions("--xr---wx")
        let expected = FilePermissions(rawValue: 0o143)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xr--r--")
    func permission_combination_100() {
        let macro = #filePermissions("--xr--r--")
        let expected = FilePermissions(rawValue: 0o144)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xr--r-x")
    func permission_combination_101() {
        let macro = #filePermissions("--xr--r-x")
        let expected = FilePermissions(rawValue: 0o145)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xr--rw-")
    func permission_combination_102() {
        let macro = #filePermissions("--xr--rw-")
        let expected = FilePermissions(rawValue: 0o146)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xr--rwx")
    func permission_combination_103() {
        let macro = #filePermissions("--xr--rwx")
        let expected = FilePermissions(rawValue: 0o147)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xr-x---")
    func permission_combination_104() {
        let macro = #filePermissions("--xr-x---")
        let expected = FilePermissions(rawValue: 0o150)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xr-x--x")
    func permission_combination_105() {
        let macro = #filePermissions("--xr-x--x")
        let expected = FilePermissions(rawValue: 0o151)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xr-x-w-")
    func permission_combination_106() {
        let macro = #filePermissions("--xr-x-w-")
        let expected = FilePermissions(rawValue: 0o152)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xr-x-wx")
    func permission_combination_107() {
        let macro = #filePermissions("--xr-x-wx")
        let expected = FilePermissions(rawValue: 0o153)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xr-xr--")
    func permission_combination_108() {
        let macro = #filePermissions("--xr-xr--")
        let expected = FilePermissions(rawValue: 0o154)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xr-xr-x")
    func permission_combination_109() {
        let macro = #filePermissions("--xr-xr-x")
        let expected = FilePermissions(rawValue: 0o155)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xr-xrw-")
    func permission_combination_110() {
        let macro = #filePermissions("--xr-xrw-")
        let expected = FilePermissions(rawValue: 0o156)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xr-xrwx")
    func permission_combination_111() {
        let macro = #filePermissions("--xr-xrwx")
        let expected = FilePermissions(rawValue: 0o157)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xrw----")
    func permission_combination_112() {
        let macro = #filePermissions("--xrw----")
        let expected = FilePermissions(rawValue: 0o160)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xrw---x")
    func permission_combination_113() {
        let macro = #filePermissions("--xrw---x")
        let expected = FilePermissions(rawValue: 0o161)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xrw--w-")
    func permission_combination_114() {
        let macro = #filePermissions("--xrw--w-")
        let expected = FilePermissions(rawValue: 0o162)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xrw--wx")
    func permission_combination_115() {
        let macro = #filePermissions("--xrw--wx")
        let expected = FilePermissions(rawValue: 0o163)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xrw-r--")
    func permission_combination_116() {
        let macro = #filePermissions("--xrw-r--")
        let expected = FilePermissions(rawValue: 0o164)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xrw-r-x")
    func permission_combination_117() {
        let macro = #filePermissions("--xrw-r-x")
        let expected = FilePermissions(rawValue: 0o165)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xrw-rw-")
    func permission_combination_118() {
        let macro = #filePermissions("--xrw-rw-")
        let expected = FilePermissions(rawValue: 0o166)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xrw-rwx")
    func permission_combination_119() {
        let macro = #filePermissions("--xrw-rwx")
        let expected = FilePermissions(rawValue: 0o167)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xrwx---")
    func permission_combination_120() {
        let macro = #filePermissions("--xrwx---")
        let expected = FilePermissions(rawValue: 0o170)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xrwx--x")
    func permission_combination_121() {
        let macro = #filePermissions("--xrwx--x")
        let expected = FilePermissions(rawValue: 0o171)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xrwx-w-")
    func permission_combination_122() {
        let macro = #filePermissions("--xrwx-w-")
        let expected = FilePermissions(rawValue: 0o172)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xrwx-wx")
    func permission_combination_123() {
        let macro = #filePermissions("--xrwx-wx")
        let expected = FilePermissions(rawValue: 0o173)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xrwxr--")
    func permission_combination_124() {
        let macro = #filePermissions("--xrwxr--")
        let expected = FilePermissions(rawValue: 0o174)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xrwxr-x")
    func permission_combination_125() {
        let macro = #filePermissions("--xrwxr-x")
        let expected = FilePermissions(rawValue: 0o175)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xrwxrw-")
    func permission_combination_126() {
        let macro = #filePermissions("--xrwxrw-")
        let expected = FilePermissions(rawValue: 0o176)
        #expect(macro == expected)
    }

    @Test("Macro evaluate --xrwxrwx")
    func permission_combination_127() {
        let macro = #filePermissions("--xrwxrwx")
        let expected = FilePermissions(rawValue: 0o177)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-------")
    func permission_combination_128() {
        let macro = #filePermissions("-w-------")
        let expected = FilePermissions(rawValue: 0o200)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w------x")
    func permission_combination_129() {
        let macro = #filePermissions("-w------x")
        let expected = FilePermissions(rawValue: 0o201)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-----w-")
    func permission_combination_130() {
        let macro = #filePermissions("-w-----w-")
        let expected = FilePermissions(rawValue: 0o202)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-----wx")
    func permission_combination_131() {
        let macro = #filePermissions("-w-----wx")
        let expected = FilePermissions(rawValue: 0o203)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w----r--")
    func permission_combination_132() {
        let macro = #filePermissions("-w----r--")
        let expected = FilePermissions(rawValue: 0o204)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w----r-x")
    func permission_combination_133() {
        let macro = #filePermissions("-w----r-x")
        let expected = FilePermissions(rawValue: 0o205)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w----rw-")
    func permission_combination_134() {
        let macro = #filePermissions("-w----rw-")
        let expected = FilePermissions(rawValue: 0o206)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w----rwx")
    func permission_combination_135() {
        let macro = #filePermissions("-w----rwx")
        let expected = FilePermissions(rawValue: 0o207)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w---x---")
    func permission_combination_136() {
        let macro = #filePermissions("-w---x---")
        let expected = FilePermissions(rawValue: 0o210)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w---x--x")
    func permission_combination_137() {
        let macro = #filePermissions("-w---x--x")
        let expected = FilePermissions(rawValue: 0o211)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w---x-w-")
    func permission_combination_138() {
        let macro = #filePermissions("-w---x-w-")
        let expected = FilePermissions(rawValue: 0o212)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w---x-wx")
    func permission_combination_139() {
        let macro = #filePermissions("-w---x-wx")
        let expected = FilePermissions(rawValue: 0o213)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w---xr--")
    func permission_combination_140() {
        let macro = #filePermissions("-w---xr--")
        let expected = FilePermissions(rawValue: 0o214)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w---xr-x")
    func permission_combination_141() {
        let macro = #filePermissions("-w---xr-x")
        let expected = FilePermissions(rawValue: 0o215)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w---xrw-")
    func permission_combination_142() {
        let macro = #filePermissions("-w---xrw-")
        let expected = FilePermissions(rawValue: 0o216)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w---xrwx")
    func permission_combination_143() {
        let macro = #filePermissions("-w---xrwx")
        let expected = FilePermissions(rawValue: 0o217)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w--w----")
    func permission_combination_144() {
        let macro = #filePermissions("-w--w----")
        let expected = FilePermissions(rawValue: 0o220)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w--w---x")
    func permission_combination_145() {
        let macro = #filePermissions("-w--w---x")
        let expected = FilePermissions(rawValue: 0o221)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w--w--w-")
    func permission_combination_146() {
        let macro = #filePermissions("-w--w--w-")
        let expected = FilePermissions(rawValue: 0o222)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w--w--wx")
    func permission_combination_147() {
        let macro = #filePermissions("-w--w--wx")
        let expected = FilePermissions(rawValue: 0o223)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w--w-r--")
    func permission_combination_148() {
        let macro = #filePermissions("-w--w-r--")
        let expected = FilePermissions(rawValue: 0o224)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w--w-r-x")
    func permission_combination_149() {
        let macro = #filePermissions("-w--w-r-x")
        let expected = FilePermissions(rawValue: 0o225)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w--w-rw-")
    func permission_combination_150() {
        let macro = #filePermissions("-w--w-rw-")
        let expected = FilePermissions(rawValue: 0o226)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w--w-rwx")
    func permission_combination_151() {
        let macro = #filePermissions("-w--w-rwx")
        let expected = FilePermissions(rawValue: 0o227)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w--wx---")
    func permission_combination_152() {
        let macro = #filePermissions("-w--wx---")
        let expected = FilePermissions(rawValue: 0o230)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w--wx--x")
    func permission_combination_153() {
        let macro = #filePermissions("-w--wx--x")
        let expected = FilePermissions(rawValue: 0o231)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w--wx-w-")
    func permission_combination_154() {
        let macro = #filePermissions("-w--wx-w-")
        let expected = FilePermissions(rawValue: 0o232)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w--wx-wx")
    func permission_combination_155() {
        let macro = #filePermissions("-w--wx-wx")
        let expected = FilePermissions(rawValue: 0o233)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w--wxr--")
    func permission_combination_156() {
        let macro = #filePermissions("-w--wxr--")
        let expected = FilePermissions(rawValue: 0o234)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w--wxr-x")
    func permission_combination_157() {
        let macro = #filePermissions("-w--wxr-x")
        let expected = FilePermissions(rawValue: 0o235)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w--wxrw-")
    func permission_combination_158() {
        let macro = #filePermissions("-w--wxrw-")
        let expected = FilePermissions(rawValue: 0o236)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w--wxrwx")
    func permission_combination_159() {
        let macro = #filePermissions("-w--wxrwx")
        let expected = FilePermissions(rawValue: 0o237)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-r-----")
    func permission_combination_160() {
        let macro = #filePermissions("-w-r-----")
        let expected = FilePermissions(rawValue: 0o240)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-r----x")
    func permission_combination_161() {
        let macro = #filePermissions("-w-r----x")
        let expected = FilePermissions(rawValue: 0o241)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-r---w-")
    func permission_combination_162() {
        let macro = #filePermissions("-w-r---w-")
        let expected = FilePermissions(rawValue: 0o242)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-r---wx")
    func permission_combination_163() {
        let macro = #filePermissions("-w-r---wx")
        let expected = FilePermissions(rawValue: 0o243)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-r--r--")
    func permission_combination_164() {
        let macro = #filePermissions("-w-r--r--")
        let expected = FilePermissions(rawValue: 0o244)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-r--r-x")
    func permission_combination_165() {
        let macro = #filePermissions("-w-r--r-x")
        let expected = FilePermissions(rawValue: 0o245)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-r--rw-")
    func permission_combination_166() {
        let macro = #filePermissions("-w-r--rw-")
        let expected = FilePermissions(rawValue: 0o246)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-r--rwx")
    func permission_combination_167() {
        let macro = #filePermissions("-w-r--rwx")
        let expected = FilePermissions(rawValue: 0o247)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-r-x---")
    func permission_combination_168() {
        let macro = #filePermissions("-w-r-x---")
        let expected = FilePermissions(rawValue: 0o250)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-r-x--x")
    func permission_combination_169() {
        let macro = #filePermissions("-w-r-x--x")
        let expected = FilePermissions(rawValue: 0o251)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-r-x-w-")
    func permission_combination_170() {
        let macro = #filePermissions("-w-r-x-w-")
        let expected = FilePermissions(rawValue: 0o252)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-r-x-wx")
    func permission_combination_171() {
        let macro = #filePermissions("-w-r-x-wx")
        let expected = FilePermissions(rawValue: 0o253)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-r-xr--")
    func permission_combination_172() {
        let macro = #filePermissions("-w-r-xr--")
        let expected = FilePermissions(rawValue: 0o254)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-r-xr-x")
    func permission_combination_173() {
        let macro = #filePermissions("-w-r-xr-x")
        let expected = FilePermissions(rawValue: 0o255)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-r-xrw-")
    func permission_combination_174() {
        let macro = #filePermissions("-w-r-xrw-")
        let expected = FilePermissions(rawValue: 0o256)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-r-xrwx")
    func permission_combination_175() {
        let macro = #filePermissions("-w-r-xrwx")
        let expected = FilePermissions(rawValue: 0o257)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-rw----")
    func permission_combination_176() {
        let macro = #filePermissions("-w-rw----")
        let expected = FilePermissions(rawValue: 0o260)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-rw---x")
    func permission_combination_177() {
        let macro = #filePermissions("-w-rw---x")
        let expected = FilePermissions(rawValue: 0o261)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-rw--w-")
    func permission_combination_178() {
        let macro = #filePermissions("-w-rw--w-")
        let expected = FilePermissions(rawValue: 0o262)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-rw--wx")
    func permission_combination_179() {
        let macro = #filePermissions("-w-rw--wx")
        let expected = FilePermissions(rawValue: 0o263)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-rw-r--")
    func permission_combination_180() {
        let macro = #filePermissions("-w-rw-r--")
        let expected = FilePermissions(rawValue: 0o264)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-rw-r-x")
    func permission_combination_181() {
        let macro = #filePermissions("-w-rw-r-x")
        let expected = FilePermissions(rawValue: 0o265)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-rw-rw-")
    func permission_combination_182() {
        let macro = #filePermissions("-w-rw-rw-")
        let expected = FilePermissions(rawValue: 0o266)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-rw-rwx")
    func permission_combination_183() {
        let macro = #filePermissions("-w-rw-rwx")
        let expected = FilePermissions(rawValue: 0o267)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-rwx---")
    func permission_combination_184() {
        let macro = #filePermissions("-w-rwx---")
        let expected = FilePermissions(rawValue: 0o270)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-rwx--x")
    func permission_combination_185() {
        let macro = #filePermissions("-w-rwx--x")
        let expected = FilePermissions(rawValue: 0o271)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-rwx-w-")
    func permission_combination_186() {
        let macro = #filePermissions("-w-rwx-w-")
        let expected = FilePermissions(rawValue: 0o272)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-rwx-wx")
    func permission_combination_187() {
        let macro = #filePermissions("-w-rwx-wx")
        let expected = FilePermissions(rawValue: 0o273)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-rwxr--")
    func permission_combination_188() {
        let macro = #filePermissions("-w-rwxr--")
        let expected = FilePermissions(rawValue: 0o274)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-rwxr-x")
    func permission_combination_189() {
        let macro = #filePermissions("-w-rwxr-x")
        let expected = FilePermissions(rawValue: 0o275)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-rwxrw-")
    func permission_combination_190() {
        let macro = #filePermissions("-w-rwxrw-")
        let expected = FilePermissions(rawValue: 0o276)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -w-rwxrwx")
    func permission_combination_191() {
        let macro = #filePermissions("-w-rwxrwx")
        let expected = FilePermissions(rawValue: 0o277)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx------")
    func permission_combination_192() {
        let macro = #filePermissions("-wx------")
        let expected = FilePermissions(rawValue: 0o300)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx-----x")
    func permission_combination_193() {
        let macro = #filePermissions("-wx-----x")
        let expected = FilePermissions(rawValue: 0o301)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx----w-")
    func permission_combination_194() {
        let macro = #filePermissions("-wx----w-")
        let expected = FilePermissions(rawValue: 0o302)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx----wx")
    func permission_combination_195() {
        let macro = #filePermissions("-wx----wx")
        let expected = FilePermissions(rawValue: 0o303)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx---r--")
    func permission_combination_196() {
        let macro = #filePermissions("-wx---r--")
        let expected = FilePermissions(rawValue: 0o304)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx---r-x")
    func permission_combination_197() {
        let macro = #filePermissions("-wx---r-x")
        let expected = FilePermissions(rawValue: 0o305)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx---rw-")
    func permission_combination_198() {
        let macro = #filePermissions("-wx---rw-")
        let expected = FilePermissions(rawValue: 0o306)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx---rwx")
    func permission_combination_199() {
        let macro = #filePermissions("-wx---rwx")
        let expected = FilePermissions(rawValue: 0o307)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx--x---")
    func permission_combination_200() {
        let macro = #filePermissions("-wx--x---")
        let expected = FilePermissions(rawValue: 0o310)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx--x--x")
    func permission_combination_201() {
        let macro = #filePermissions("-wx--x--x")
        let expected = FilePermissions(rawValue: 0o311)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx--x-w-")
    func permission_combination_202() {
        let macro = #filePermissions("-wx--x-w-")
        let expected = FilePermissions(rawValue: 0o312)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx--x-wx")
    func permission_combination_203() {
        let macro = #filePermissions("-wx--x-wx")
        let expected = FilePermissions(rawValue: 0o313)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx--xr--")
    func permission_combination_204() {
        let macro = #filePermissions("-wx--xr--")
        let expected = FilePermissions(rawValue: 0o314)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx--xr-x")
    func permission_combination_205() {
        let macro = #filePermissions("-wx--xr-x")
        let expected = FilePermissions(rawValue: 0o315)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx--xrw-")
    func permission_combination_206() {
        let macro = #filePermissions("-wx--xrw-")
        let expected = FilePermissions(rawValue: 0o316)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx--xrwx")
    func permission_combination_207() {
        let macro = #filePermissions("-wx--xrwx")
        let expected = FilePermissions(rawValue: 0o317)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx-w----")
    func permission_combination_208() {
        let macro = #filePermissions("-wx-w----")
        let expected = FilePermissions(rawValue: 0o320)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx-w---x")
    func permission_combination_209() {
        let macro = #filePermissions("-wx-w---x")
        let expected = FilePermissions(rawValue: 0o321)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx-w--w-")
    func permission_combination_210() {
        let macro = #filePermissions("-wx-w--w-")
        let expected = FilePermissions(rawValue: 0o322)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx-w--wx")
    func permission_combination_211() {
        let macro = #filePermissions("-wx-w--wx")
        let expected = FilePermissions(rawValue: 0o323)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx-w-r--")
    func permission_combination_212() {
        let macro = #filePermissions("-wx-w-r--")
        let expected = FilePermissions(rawValue: 0o324)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx-w-r-x")
    func permission_combination_213() {
        let macro = #filePermissions("-wx-w-r-x")
        let expected = FilePermissions(rawValue: 0o325)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx-w-rw-")
    func permission_combination_214() {
        let macro = #filePermissions("-wx-w-rw-")
        let expected = FilePermissions(rawValue: 0o326)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx-w-rwx")
    func permission_combination_215() {
        let macro = #filePermissions("-wx-w-rwx")
        let expected = FilePermissions(rawValue: 0o327)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx-wx---")
    func permission_combination_216() {
        let macro = #filePermissions("-wx-wx---")
        let expected = FilePermissions(rawValue: 0o330)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx-wx--x")
    func permission_combination_217() {
        let macro = #filePermissions("-wx-wx--x")
        let expected = FilePermissions(rawValue: 0o331)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx-wx-w-")
    func permission_combination_218() {
        let macro = #filePermissions("-wx-wx-w-")
        let expected = FilePermissions(rawValue: 0o332)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx-wx-wx")
    func permission_combination_219() {
        let macro = #filePermissions("-wx-wx-wx")
        let expected = FilePermissions(rawValue: 0o333)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx-wxr--")
    func permission_combination_220() {
        let macro = #filePermissions("-wx-wxr--")
        let expected = FilePermissions(rawValue: 0o334)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx-wxr-x")
    func permission_combination_221() {
        let macro = #filePermissions("-wx-wxr-x")
        let expected = FilePermissions(rawValue: 0o335)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx-wxrw-")
    func permission_combination_222() {
        let macro = #filePermissions("-wx-wxrw-")
        let expected = FilePermissions(rawValue: 0o336)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wx-wxrwx")
    func permission_combination_223() {
        let macro = #filePermissions("-wx-wxrwx")
        let expected = FilePermissions(rawValue: 0o337)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxr-----")
    func permission_combination_224() {
        let macro = #filePermissions("-wxr-----")
        let expected = FilePermissions(rawValue: 0o340)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxr----x")
    func permission_combination_225() {
        let macro = #filePermissions("-wxr----x")
        let expected = FilePermissions(rawValue: 0o341)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxr---w-")
    func permission_combination_226() {
        let macro = #filePermissions("-wxr---w-")
        let expected = FilePermissions(rawValue: 0o342)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxr---wx")
    func permission_combination_227() {
        let macro = #filePermissions("-wxr---wx")
        let expected = FilePermissions(rawValue: 0o343)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxr--r--")
    func permission_combination_228() {
        let macro = #filePermissions("-wxr--r--")
        let expected = FilePermissions(rawValue: 0o344)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxr--r-x")
    func permission_combination_229() {
        let macro = #filePermissions("-wxr--r-x")
        let expected = FilePermissions(rawValue: 0o345)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxr--rw-")
    func permission_combination_230() {
        let macro = #filePermissions("-wxr--rw-")
        let expected = FilePermissions(rawValue: 0o346)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxr--rwx")
    func permission_combination_231() {
        let macro = #filePermissions("-wxr--rwx")
        let expected = FilePermissions(rawValue: 0o347)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxr-x---")
    func permission_combination_232() {
        let macro = #filePermissions("-wxr-x---")
        let expected = FilePermissions(rawValue: 0o350)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxr-x--x")
    func permission_combination_233() {
        let macro = #filePermissions("-wxr-x--x")
        let expected = FilePermissions(rawValue: 0o351)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxr-x-w-")
    func permission_combination_234() {
        let macro = #filePermissions("-wxr-x-w-")
        let expected = FilePermissions(rawValue: 0o352)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxr-x-wx")
    func permission_combination_235() {
        let macro = #filePermissions("-wxr-x-wx")
        let expected = FilePermissions(rawValue: 0o353)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxr-xr--")
    func permission_combination_236() {
        let macro = #filePermissions("-wxr-xr--")
        let expected = FilePermissions(rawValue: 0o354)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxr-xr-x")
    func permission_combination_237() {
        let macro = #filePermissions("-wxr-xr-x")
        let expected = FilePermissions(rawValue: 0o355)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxr-xrw-")
    func permission_combination_238() {
        let macro = #filePermissions("-wxr-xrw-")
        let expected = FilePermissions(rawValue: 0o356)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxr-xrwx")
    func permission_combination_239() {
        let macro = #filePermissions("-wxr-xrwx")
        let expected = FilePermissions(rawValue: 0o357)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxrw----")
    func permission_combination_240() {
        let macro = #filePermissions("-wxrw----")
        let expected = FilePermissions(rawValue: 0o360)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxrw---x")
    func permission_combination_241() {
        let macro = #filePermissions("-wxrw---x")
        let expected = FilePermissions(rawValue: 0o361)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxrw--w-")
    func permission_combination_242() {
        let macro = #filePermissions("-wxrw--w-")
        let expected = FilePermissions(rawValue: 0o362)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxrw--wx")
    func permission_combination_243() {
        let macro = #filePermissions("-wxrw--wx")
        let expected = FilePermissions(rawValue: 0o363)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxrw-r--")
    func permission_combination_244() {
        let macro = #filePermissions("-wxrw-r--")
        let expected = FilePermissions(rawValue: 0o364)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxrw-r-x")
    func permission_combination_245() {
        let macro = #filePermissions("-wxrw-r-x")
        let expected = FilePermissions(rawValue: 0o365)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxrw-rw-")
    func permission_combination_246() {
        let macro = #filePermissions("-wxrw-rw-")
        let expected = FilePermissions(rawValue: 0o366)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxrw-rwx")
    func permission_combination_247() {
        let macro = #filePermissions("-wxrw-rwx")
        let expected = FilePermissions(rawValue: 0o367)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxrwx---")
    func permission_combination_248() {
        let macro = #filePermissions("-wxrwx---")
        let expected = FilePermissions(rawValue: 0o370)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxrwx--x")
    func permission_combination_249() {
        let macro = #filePermissions("-wxrwx--x")
        let expected = FilePermissions(rawValue: 0o371)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxrwx-w-")
    func permission_combination_250() {
        let macro = #filePermissions("-wxrwx-w-")
        let expected = FilePermissions(rawValue: 0o372)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxrwx-wx")
    func permission_combination_251() {
        let macro = #filePermissions("-wxrwx-wx")
        let expected = FilePermissions(rawValue: 0o373)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxrwxr--")
    func permission_combination_252() {
        let macro = #filePermissions("-wxrwxr--")
        let expected = FilePermissions(rawValue: 0o374)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxrwxr-x")
    func permission_combination_253() {
        let macro = #filePermissions("-wxrwxr-x")
        let expected = FilePermissions(rawValue: 0o375)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxrwxrw-")
    func permission_combination_254() {
        let macro = #filePermissions("-wxrwxrw-")
        let expected = FilePermissions(rawValue: 0o376)
        #expect(macro == expected)
    }

    @Test("Macro evaluate -wxrwxrwx")
    func permission_combination_255() {
        let macro = #filePermissions("-wxrwxrwx")
        let expected = FilePermissions(rawValue: 0o377)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--------")
    func permission_combination_256() {
        let macro = #filePermissions("r--------")
        let expected = FilePermissions(rawValue: 0o400)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-------x")
    func permission_combination_257() {
        let macro = #filePermissions("r-------x")
        let expected = FilePermissions(rawValue: 0o401)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r------w-")
    func permission_combination_258() {
        let macro = #filePermissions("r------w-")
        let expected = FilePermissions(rawValue: 0o402)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r------wx")
    func permission_combination_259() {
        let macro = #filePermissions("r------wx")
        let expected = FilePermissions(rawValue: 0o403)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-----r--")
    func permission_combination_260() {
        let macro = #filePermissions("r-----r--")
        let expected = FilePermissions(rawValue: 0o404)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-----r-x")
    func permission_combination_261() {
        let macro = #filePermissions("r-----r-x")
        let expected = FilePermissions(rawValue: 0o405)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-----rw-")
    func permission_combination_262() {
        let macro = #filePermissions("r-----rw-")
        let expected = FilePermissions(rawValue: 0o406)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-----rwx")
    func permission_combination_263() {
        let macro = #filePermissions("r-----rwx")
        let expected = FilePermissions(rawValue: 0o407)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r----x---")
    func permission_combination_264() {
        let macro = #filePermissions("r----x---")
        let expected = FilePermissions(rawValue: 0o410)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r----x--x")
    func permission_combination_265() {
        let macro = #filePermissions("r----x--x")
        let expected = FilePermissions(rawValue: 0o411)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r----x-w-")
    func permission_combination_266() {
        let macro = #filePermissions("r----x-w-")
        let expected = FilePermissions(rawValue: 0o412)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r----x-wx")
    func permission_combination_267() {
        let macro = #filePermissions("r----x-wx")
        let expected = FilePermissions(rawValue: 0o413)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r----xr--")
    func permission_combination_268() {
        let macro = #filePermissions("r----xr--")
        let expected = FilePermissions(rawValue: 0o414)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r----xr-x")
    func permission_combination_269() {
        let macro = #filePermissions("r----xr-x")
        let expected = FilePermissions(rawValue: 0o415)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r----xrw-")
    func permission_combination_270() {
        let macro = #filePermissions("r----xrw-")
        let expected = FilePermissions(rawValue: 0o416)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r----xrwx")
    func permission_combination_271() {
        let macro = #filePermissions("r----xrwx")
        let expected = FilePermissions(rawValue: 0o417)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r---w----")
    func permission_combination_272() {
        let macro = #filePermissions("r---w----")
        let expected = FilePermissions(rawValue: 0o420)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r---w---x")
    func permission_combination_273() {
        let macro = #filePermissions("r---w---x")
        let expected = FilePermissions(rawValue: 0o421)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r---w--w-")
    func permission_combination_274() {
        let macro = #filePermissions("r---w--w-")
        let expected = FilePermissions(rawValue: 0o422)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r---w--wx")
    func permission_combination_275() {
        let macro = #filePermissions("r---w--wx")
        let expected = FilePermissions(rawValue: 0o423)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r---w-r--")
    func permission_combination_276() {
        let macro = #filePermissions("r---w-r--")
        let expected = FilePermissions(rawValue: 0o424)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r---w-r-x")
    func permission_combination_277() {
        let macro = #filePermissions("r---w-r-x")
        let expected = FilePermissions(rawValue: 0o425)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r---w-rw-")
    func permission_combination_278() {
        let macro = #filePermissions("r---w-rw-")
        let expected = FilePermissions(rawValue: 0o426)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r---w-rwx")
    func permission_combination_279() {
        let macro = #filePermissions("r---w-rwx")
        let expected = FilePermissions(rawValue: 0o427)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r---wx---")
    func permission_combination_280() {
        let macro = #filePermissions("r---wx---")
        let expected = FilePermissions(rawValue: 0o430)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r---wx--x")
    func permission_combination_281() {
        let macro = #filePermissions("r---wx--x")
        let expected = FilePermissions(rawValue: 0o431)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r---wx-w-")
    func permission_combination_282() {
        let macro = #filePermissions("r---wx-w-")
        let expected = FilePermissions(rawValue: 0o432)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r---wx-wx")
    func permission_combination_283() {
        let macro = #filePermissions("r---wx-wx")
        let expected = FilePermissions(rawValue: 0o433)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r---wxr--")
    func permission_combination_284() {
        let macro = #filePermissions("r---wxr--")
        let expected = FilePermissions(rawValue: 0o434)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r---wxr-x")
    func permission_combination_285() {
        let macro = #filePermissions("r---wxr-x")
        let expected = FilePermissions(rawValue: 0o435)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r---wxrw-")
    func permission_combination_286() {
        let macro = #filePermissions("r---wxrw-")
        let expected = FilePermissions(rawValue: 0o436)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r---wxrwx")
    func permission_combination_287() {
        let macro = #filePermissions("r---wxrwx")
        let expected = FilePermissions(rawValue: 0o437)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--r-----")
    func permission_combination_288() {
        let macro = #filePermissions("r--r-----")
        let expected = FilePermissions(rawValue: 0o440)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--r----x")
    func permission_combination_289() {
        let macro = #filePermissions("r--r----x")
        let expected = FilePermissions(rawValue: 0o441)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--r---w-")
    func permission_combination_290() {
        let macro = #filePermissions("r--r---w-")
        let expected = FilePermissions(rawValue: 0o442)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--r---wx")
    func permission_combination_291() {
        let macro = #filePermissions("r--r---wx")
        let expected = FilePermissions(rawValue: 0o443)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--r--r--")
    func permission_combination_292() {
        let macro = #filePermissions("r--r--r--")
        let expected = FilePermissions(rawValue: 0o444)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--r--r-x")
    func permission_combination_293() {
        let macro = #filePermissions("r--r--r-x")
        let expected = FilePermissions(rawValue: 0o445)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--r--rw-")
    func permission_combination_294() {
        let macro = #filePermissions("r--r--rw-")
        let expected = FilePermissions(rawValue: 0o446)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--r--rwx")
    func permission_combination_295() {
        let macro = #filePermissions("r--r--rwx")
        let expected = FilePermissions(rawValue: 0o447)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--r-x---")
    func permission_combination_296() {
        let macro = #filePermissions("r--r-x---")
        let expected = FilePermissions(rawValue: 0o450)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--r-x--x")
    func permission_combination_297() {
        let macro = #filePermissions("r--r-x--x")
        let expected = FilePermissions(rawValue: 0o451)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--r-x-w-")
    func permission_combination_298() {
        let macro = #filePermissions("r--r-x-w-")
        let expected = FilePermissions(rawValue: 0o452)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--r-x-wx")
    func permission_combination_299() {
        let macro = #filePermissions("r--r-x-wx")
        let expected = FilePermissions(rawValue: 0o453)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--r-xr--")
    func permission_combination_300() {
        let macro = #filePermissions("r--r-xr--")
        let expected = FilePermissions(rawValue: 0o454)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--r-xr-x")
    func permission_combination_301() {
        let macro = #filePermissions("r--r-xr-x")
        let expected = FilePermissions(rawValue: 0o455)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--r-xrw-")
    func permission_combination_302() {
        let macro = #filePermissions("r--r-xrw-")
        let expected = FilePermissions(rawValue: 0o456)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--r-xrwx")
    func permission_combination_303() {
        let macro = #filePermissions("r--r-xrwx")
        let expected = FilePermissions(rawValue: 0o457)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--rw----")
    func permission_combination_304() {
        let macro = #filePermissions("r--rw----")
        let expected = FilePermissions(rawValue: 0o460)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--rw---x")
    func permission_combination_305() {
        let macro = #filePermissions("r--rw---x")
        let expected = FilePermissions(rawValue: 0o461)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--rw--w-")
    func permission_combination_306() {
        let macro = #filePermissions("r--rw--w-")
        let expected = FilePermissions(rawValue: 0o462)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--rw--wx")
    func permission_combination_307() {
        let macro = #filePermissions("r--rw--wx")
        let expected = FilePermissions(rawValue: 0o463)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--rw-r--")
    func permission_combination_308() {
        let macro = #filePermissions("r--rw-r--")
        let expected = FilePermissions(rawValue: 0o464)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--rw-r-x")
    func permission_combination_309() {
        let macro = #filePermissions("r--rw-r-x")
        let expected = FilePermissions(rawValue: 0o465)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--rw-rw-")
    func permission_combination_310() {
        let macro = #filePermissions("r--rw-rw-")
        let expected = FilePermissions(rawValue: 0o466)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--rw-rwx")
    func permission_combination_311() {
        let macro = #filePermissions("r--rw-rwx")
        let expected = FilePermissions(rawValue: 0o467)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--rwx---")
    func permission_combination_312() {
        let macro = #filePermissions("r--rwx---")
        let expected = FilePermissions(rawValue: 0o470)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--rwx--x")
    func permission_combination_313() {
        let macro = #filePermissions("r--rwx--x")
        let expected = FilePermissions(rawValue: 0o471)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--rwx-w-")
    func permission_combination_314() {
        let macro = #filePermissions("r--rwx-w-")
        let expected = FilePermissions(rawValue: 0o472)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--rwx-wx")
    func permission_combination_315() {
        let macro = #filePermissions("r--rwx-wx")
        let expected = FilePermissions(rawValue: 0o473)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--rwxr--")
    func permission_combination_316() {
        let macro = #filePermissions("r--rwxr--")
        let expected = FilePermissions(rawValue: 0o474)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--rwxr-x")
    func permission_combination_317() {
        let macro = #filePermissions("r--rwxr-x")
        let expected = FilePermissions(rawValue: 0o475)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--rwxrw-")
    func permission_combination_318() {
        let macro = #filePermissions("r--rwxrw-")
        let expected = FilePermissions(rawValue: 0o476)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r--rwxrwx")
    func permission_combination_319() {
        let macro = #filePermissions("r--rwxrwx")
        let expected = FilePermissions(rawValue: 0o477)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x------")
    func permission_combination_320() {
        let macro = #filePermissions("r-x------")
        let expected = FilePermissions(rawValue: 0o500)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x-----x")
    func permission_combination_321() {
        let macro = #filePermissions("r-x-----x")
        let expected = FilePermissions(rawValue: 0o501)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x----w-")
    func permission_combination_322() {
        let macro = #filePermissions("r-x----w-")
        let expected = FilePermissions(rawValue: 0o502)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x----wx")
    func permission_combination_323() {
        let macro = #filePermissions("r-x----wx")
        let expected = FilePermissions(rawValue: 0o503)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x---r--")
    func permission_combination_324() {
        let macro = #filePermissions("r-x---r--")
        let expected = FilePermissions(rawValue: 0o504)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x---r-x")
    func permission_combination_325() {
        let macro = #filePermissions("r-x---r-x")
        let expected = FilePermissions(rawValue: 0o505)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x---rw-")
    func permission_combination_326() {
        let macro = #filePermissions("r-x---rw-")
        let expected = FilePermissions(rawValue: 0o506)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x---rwx")
    func permission_combination_327() {
        let macro = #filePermissions("r-x---rwx")
        let expected = FilePermissions(rawValue: 0o507)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x--x---")
    func permission_combination_328() {
        let macro = #filePermissions("r-x--x---")
        let expected = FilePermissions(rawValue: 0o510)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x--x--x")
    func permission_combination_329() {
        let macro = #filePermissions("r-x--x--x")
        let expected = FilePermissions(rawValue: 0o511)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x--x-w-")
    func permission_combination_330() {
        let macro = #filePermissions("r-x--x-w-")
        let expected = FilePermissions(rawValue: 0o512)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x--x-wx")
    func permission_combination_331() {
        let macro = #filePermissions("r-x--x-wx")
        let expected = FilePermissions(rawValue: 0o513)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x--xr--")
    func permission_combination_332() {
        let macro = #filePermissions("r-x--xr--")
        let expected = FilePermissions(rawValue: 0o514)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x--xr-x")
    func permission_combination_333() {
        let macro = #filePermissions("r-x--xr-x")
        let expected = FilePermissions(rawValue: 0o515)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x--xrw-")
    func permission_combination_334() {
        let macro = #filePermissions("r-x--xrw-")
        let expected = FilePermissions(rawValue: 0o516)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x--xrwx")
    func permission_combination_335() {
        let macro = #filePermissions("r-x--xrwx")
        let expected = FilePermissions(rawValue: 0o517)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x-w----")
    func permission_combination_336() {
        let macro = #filePermissions("r-x-w----")
        let expected = FilePermissions(rawValue: 0o520)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x-w---x")
    func permission_combination_337() {
        let macro = #filePermissions("r-x-w---x")
        let expected = FilePermissions(rawValue: 0o521)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x-w--w-")
    func permission_combination_338() {
        let macro = #filePermissions("r-x-w--w-")
        let expected = FilePermissions(rawValue: 0o522)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x-w--wx")
    func permission_combination_339() {
        let macro = #filePermissions("r-x-w--wx")
        let expected = FilePermissions(rawValue: 0o523)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x-w-r--")
    func permission_combination_340() {
        let macro = #filePermissions("r-x-w-r--")
        let expected = FilePermissions(rawValue: 0o524)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x-w-r-x")
    func permission_combination_341() {
        let macro = #filePermissions("r-x-w-r-x")
        let expected = FilePermissions(rawValue: 0o525)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x-w-rw-")
    func permission_combination_342() {
        let macro = #filePermissions("r-x-w-rw-")
        let expected = FilePermissions(rawValue: 0o526)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x-w-rwx")
    func permission_combination_343() {
        let macro = #filePermissions("r-x-w-rwx")
        let expected = FilePermissions(rawValue: 0o527)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x-wx---")
    func permission_combination_344() {
        let macro = #filePermissions("r-x-wx---")
        let expected = FilePermissions(rawValue: 0o530)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x-wx--x")
    func permission_combination_345() {
        let macro = #filePermissions("r-x-wx--x")
        let expected = FilePermissions(rawValue: 0o531)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x-wx-w-")
    func permission_combination_346() {
        let macro = #filePermissions("r-x-wx-w-")
        let expected = FilePermissions(rawValue: 0o532)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x-wx-wx")
    func permission_combination_347() {
        let macro = #filePermissions("r-x-wx-wx")
        let expected = FilePermissions(rawValue: 0o533)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x-wxr--")
    func permission_combination_348() {
        let macro = #filePermissions("r-x-wxr--")
        let expected = FilePermissions(rawValue: 0o534)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x-wxr-x")
    func permission_combination_349() {
        let macro = #filePermissions("r-x-wxr-x")
        let expected = FilePermissions(rawValue: 0o535)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x-wxrw-")
    func permission_combination_350() {
        let macro = #filePermissions("r-x-wxrw-")
        let expected = FilePermissions(rawValue: 0o536)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-x-wxrwx")
    func permission_combination_351() {
        let macro = #filePermissions("r-x-wxrwx")
        let expected = FilePermissions(rawValue: 0o537)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xr-----")
    func permission_combination_352() {
        let macro = #filePermissions("r-xr-----")
        let expected = FilePermissions(rawValue: 0o540)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xr----x")
    func permission_combination_353() {
        let macro = #filePermissions("r-xr----x")
        let expected = FilePermissions(rawValue: 0o541)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xr---w-")
    func permission_combination_354() {
        let macro = #filePermissions("r-xr---w-")
        let expected = FilePermissions(rawValue: 0o542)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xr---wx")
    func permission_combination_355() {
        let macro = #filePermissions("r-xr---wx")
        let expected = FilePermissions(rawValue: 0o543)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xr--r--")
    func permission_combination_356() {
        let macro = #filePermissions("r-xr--r--")
        let expected = FilePermissions(rawValue: 0o544)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xr--r-x")
    func permission_combination_357() {
        let macro = #filePermissions("r-xr--r-x")
        let expected = FilePermissions(rawValue: 0o545)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xr--rw-")
    func permission_combination_358() {
        let macro = #filePermissions("r-xr--rw-")
        let expected = FilePermissions(rawValue: 0o546)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xr--rwx")
    func permission_combination_359() {
        let macro = #filePermissions("r-xr--rwx")
        let expected = FilePermissions(rawValue: 0o547)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xr-x---")
    func permission_combination_360() {
        let macro = #filePermissions("r-xr-x---")
        let expected = FilePermissions(rawValue: 0o550)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xr-x--x")
    func permission_combination_361() {
        let macro = #filePermissions("r-xr-x--x")
        let expected = FilePermissions(rawValue: 0o551)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xr-x-w-")
    func permission_combination_362() {
        let macro = #filePermissions("r-xr-x-w-")
        let expected = FilePermissions(rawValue: 0o552)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xr-x-wx")
    func permission_combination_363() {
        let macro = #filePermissions("r-xr-x-wx")
        let expected = FilePermissions(rawValue: 0o553)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xr-xr--")
    func permission_combination_364() {
        let macro = #filePermissions("r-xr-xr--")
        let expected = FilePermissions(rawValue: 0o554)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xr-xr-x")
    func permission_combination_365() {
        let macro = #filePermissions("r-xr-xr-x")
        let expected = FilePermissions(rawValue: 0o555)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xr-xrw-")
    func permission_combination_366() {
        let macro = #filePermissions("r-xr-xrw-")
        let expected = FilePermissions(rawValue: 0o556)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xr-xrwx")
    func permission_combination_367() {
        let macro = #filePermissions("r-xr-xrwx")
        let expected = FilePermissions(rawValue: 0o557)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xrw----")
    func permission_combination_368() {
        let macro = #filePermissions("r-xrw----")
        let expected = FilePermissions(rawValue: 0o560)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xrw---x")
    func permission_combination_369() {
        let macro = #filePermissions("r-xrw---x")
        let expected = FilePermissions(rawValue: 0o561)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xrw--w-")
    func permission_combination_370() {
        let macro = #filePermissions("r-xrw--w-")
        let expected = FilePermissions(rawValue: 0o562)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xrw--wx")
    func permission_combination_371() {
        let macro = #filePermissions("r-xrw--wx")
        let expected = FilePermissions(rawValue: 0o563)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xrw-r--")
    func permission_combination_372() {
        let macro = #filePermissions("r-xrw-r--")
        let expected = FilePermissions(rawValue: 0o564)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xrw-r-x")
    func permission_combination_373() {
        let macro = #filePermissions("r-xrw-r-x")
        let expected = FilePermissions(rawValue: 0o565)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xrw-rw-")
    func permission_combination_374() {
        let macro = #filePermissions("r-xrw-rw-")
        let expected = FilePermissions(rawValue: 0o566)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xrw-rwx")
    func permission_combination_375() {
        let macro = #filePermissions("r-xrw-rwx")
        let expected = FilePermissions(rawValue: 0o567)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xrwx---")
    func permission_combination_376() {
        let macro = #filePermissions("r-xrwx---")
        let expected = FilePermissions(rawValue: 0o570)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xrwx--x")
    func permission_combination_377() {
        let macro = #filePermissions("r-xrwx--x")
        let expected = FilePermissions(rawValue: 0o571)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xrwx-w-")
    func permission_combination_378() {
        let macro = #filePermissions("r-xrwx-w-")
        let expected = FilePermissions(rawValue: 0o572)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xrwx-wx")
    func permission_combination_379() {
        let macro = #filePermissions("r-xrwx-wx")
        let expected = FilePermissions(rawValue: 0o573)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xrwxr--")
    func permission_combination_380() {
        let macro = #filePermissions("r-xrwxr--")
        let expected = FilePermissions(rawValue: 0o574)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xrwxr-x")
    func permission_combination_381() {
        let macro = #filePermissions("r-xrwxr-x")
        let expected = FilePermissions(rawValue: 0o575)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xrwxrw-")
    func permission_combination_382() {
        let macro = #filePermissions("r-xrwxrw-")
        let expected = FilePermissions(rawValue: 0o576)
        #expect(macro == expected)
    }

    @Test("Macro evaluate r-xrwxrwx")
    func permission_combination_383() {
        let macro = #filePermissions("r-xrwxrwx")
        let expected = FilePermissions(rawValue: 0o577)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-------")
    func permission_combination_384() {
        let macro = #filePermissions("rw-------")
        let expected = FilePermissions(rawValue: 0o600)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw------x")
    func permission_combination_385() {
        let macro = #filePermissions("rw------x")
        let expected = FilePermissions(rawValue: 0o601)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-----w-")
    func permission_combination_386() {
        let macro = #filePermissions("rw-----w-")
        let expected = FilePermissions(rawValue: 0o602)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-----wx")
    func permission_combination_387() {
        let macro = #filePermissions("rw-----wx")
        let expected = FilePermissions(rawValue: 0o603)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw----r--")
    func permission_combination_388() {
        let macro = #filePermissions("rw----r--")
        let expected = FilePermissions(rawValue: 0o604)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw----r-x")
    func permission_combination_389() {
        let macro = #filePermissions("rw----r-x")
        let expected = FilePermissions(rawValue: 0o605)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw----rw-")
    func permission_combination_390() {
        let macro = #filePermissions("rw----rw-")
        let expected = FilePermissions(rawValue: 0o606)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw----rwx")
    func permission_combination_391() {
        let macro = #filePermissions("rw----rwx")
        let expected = FilePermissions(rawValue: 0o607)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw---x---")
    func permission_combination_392() {
        let macro = #filePermissions("rw---x---")
        let expected = FilePermissions(rawValue: 0o610)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw---x--x")
    func permission_combination_393() {
        let macro = #filePermissions("rw---x--x")
        let expected = FilePermissions(rawValue: 0o611)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw---x-w-")
    func permission_combination_394() {
        let macro = #filePermissions("rw---x-w-")
        let expected = FilePermissions(rawValue: 0o612)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw---x-wx")
    func permission_combination_395() {
        let macro = #filePermissions("rw---x-wx")
        let expected = FilePermissions(rawValue: 0o613)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw---xr--")
    func permission_combination_396() {
        let macro = #filePermissions("rw---xr--")
        let expected = FilePermissions(rawValue: 0o614)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw---xr-x")
    func permission_combination_397() {
        let macro = #filePermissions("rw---xr-x")
        let expected = FilePermissions(rawValue: 0o615)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw---xrw-")
    func permission_combination_398() {
        let macro = #filePermissions("rw---xrw-")
        let expected = FilePermissions(rawValue: 0o616)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw---xrwx")
    func permission_combination_399() {
        let macro = #filePermissions("rw---xrwx")
        let expected = FilePermissions(rawValue: 0o617)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw--w----")
    func permission_combination_400() {
        let macro = #filePermissions("rw--w----")
        let expected = FilePermissions(rawValue: 0o620)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw--w---x")
    func permission_combination_401() {
        let macro = #filePermissions("rw--w---x")
        let expected = FilePermissions(rawValue: 0o621)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw--w--w-")
    func permission_combination_402() {
        let macro = #filePermissions("rw--w--w-")
        let expected = FilePermissions(rawValue: 0o622)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw--w--wx")
    func permission_combination_403() {
        let macro = #filePermissions("rw--w--wx")
        let expected = FilePermissions(rawValue: 0o623)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw--w-r--")
    func permission_combination_404() {
        let macro = #filePermissions("rw--w-r--")
        let expected = FilePermissions(rawValue: 0o624)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw--w-r-x")
    func permission_combination_405() {
        let macro = #filePermissions("rw--w-r-x")
        let expected = FilePermissions(rawValue: 0o625)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw--w-rw-")
    func permission_combination_406() {
        let macro = #filePermissions("rw--w-rw-")
        let expected = FilePermissions(rawValue: 0o626)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw--w-rwx")
    func permission_combination_407() {
        let macro = #filePermissions("rw--w-rwx")
        let expected = FilePermissions(rawValue: 0o627)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw--wx---")
    func permission_combination_408() {
        let macro = #filePermissions("rw--wx---")
        let expected = FilePermissions(rawValue: 0o630)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw--wx--x")
    func permission_combination_409() {
        let macro = #filePermissions("rw--wx--x")
        let expected = FilePermissions(rawValue: 0o631)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw--wx-w-")
    func permission_combination_410() {
        let macro = #filePermissions("rw--wx-w-")
        let expected = FilePermissions(rawValue: 0o632)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw--wx-wx")
    func permission_combination_411() {
        let macro = #filePermissions("rw--wx-wx")
        let expected = FilePermissions(rawValue: 0o633)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw--wxr--")
    func permission_combination_412() {
        let macro = #filePermissions("rw--wxr--")
        let expected = FilePermissions(rawValue: 0o634)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw--wxr-x")
    func permission_combination_413() {
        let macro = #filePermissions("rw--wxr-x")
        let expected = FilePermissions(rawValue: 0o635)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw--wxrw-")
    func permission_combination_414() {
        let macro = #filePermissions("rw--wxrw-")
        let expected = FilePermissions(rawValue: 0o636)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw--wxrwx")
    func permission_combination_415() {
        let macro = #filePermissions("rw--wxrwx")
        let expected = FilePermissions(rawValue: 0o637)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-r-----")
    func permission_combination_416() {
        let macro = #filePermissions("rw-r-----")
        let expected = FilePermissions(rawValue: 0o640)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-r----x")
    func permission_combination_417() {
        let macro = #filePermissions("rw-r----x")
        let expected = FilePermissions(rawValue: 0o641)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-r---w-")
    func permission_combination_418() {
        let macro = #filePermissions("rw-r---w-")
        let expected = FilePermissions(rawValue: 0o642)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-r---wx")
    func permission_combination_419() {
        let macro = #filePermissions("rw-r---wx")
        let expected = FilePermissions(rawValue: 0o643)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-r--r--")
    func permission_combination_420() {
        let macro = #filePermissions("rw-r--r--")
        let expected = FilePermissions(rawValue: 0o644)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-r--r-x")
    func permission_combination_421() {
        let macro = #filePermissions("rw-r--r-x")
        let expected = FilePermissions(rawValue: 0o645)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-r--rw-")
    func permission_combination_422() {
        let macro = #filePermissions("rw-r--rw-")
        let expected = FilePermissions(rawValue: 0o646)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-r--rwx")
    func permission_combination_423() {
        let macro = #filePermissions("rw-r--rwx")
        let expected = FilePermissions(rawValue: 0o647)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-r-x---")
    func permission_combination_424() {
        let macro = #filePermissions("rw-r-x---")
        let expected = FilePermissions(rawValue: 0o650)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-r-x--x")
    func permission_combination_425() {
        let macro = #filePermissions("rw-r-x--x")
        let expected = FilePermissions(rawValue: 0o651)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-r-x-w-")
    func permission_combination_426() {
        let macro = #filePermissions("rw-r-x-w-")
        let expected = FilePermissions(rawValue: 0o652)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-r-x-wx")
    func permission_combination_427() {
        let macro = #filePermissions("rw-r-x-wx")
        let expected = FilePermissions(rawValue: 0o653)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-r-xr--")
    func permission_combination_428() {
        let macro = #filePermissions("rw-r-xr--")
        let expected = FilePermissions(rawValue: 0o654)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-r-xr-x")
    func permission_combination_429() {
        let macro = #filePermissions("rw-r-xr-x")
        let expected = FilePermissions(rawValue: 0o655)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-r-xrw-")
    func permission_combination_430() {
        let macro = #filePermissions("rw-r-xrw-")
        let expected = FilePermissions(rawValue: 0o656)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-r-xrwx")
    func permission_combination_431() {
        let macro = #filePermissions("rw-r-xrwx")
        let expected = FilePermissions(rawValue: 0o657)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-rw----")
    func permission_combination_432() {
        let macro = #filePermissions("rw-rw----")
        let expected = FilePermissions(rawValue: 0o660)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-rw---x")
    func permission_combination_433() {
        let macro = #filePermissions("rw-rw---x")
        let expected = FilePermissions(rawValue: 0o661)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-rw--w-")
    func permission_combination_434() {
        let macro = #filePermissions("rw-rw--w-")
        let expected = FilePermissions(rawValue: 0o662)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-rw--wx")
    func permission_combination_435() {
        let macro = #filePermissions("rw-rw--wx")
        let expected = FilePermissions(rawValue: 0o663)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-rw-r--")
    func permission_combination_436() {
        let macro = #filePermissions("rw-rw-r--")
        let expected = FilePermissions(rawValue: 0o664)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-rw-r-x")
    func permission_combination_437() {
        let macro = #filePermissions("rw-rw-r-x")
        let expected = FilePermissions(rawValue: 0o665)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-rw-rw-")
    func permission_combination_438() {
        let macro = #filePermissions("rw-rw-rw-")
        let expected = FilePermissions(rawValue: 0o666)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-rw-rwx")
    func permission_combination_439() {
        let macro = #filePermissions("rw-rw-rwx")
        let expected = FilePermissions(rawValue: 0o667)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-rwx---")
    func permission_combination_440() {
        let macro = #filePermissions("rw-rwx---")
        let expected = FilePermissions(rawValue: 0o670)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-rwx--x")
    func permission_combination_441() {
        let macro = #filePermissions("rw-rwx--x")
        let expected = FilePermissions(rawValue: 0o671)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-rwx-w-")
    func permission_combination_442() {
        let macro = #filePermissions("rw-rwx-w-")
        let expected = FilePermissions(rawValue: 0o672)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-rwx-wx")
    func permission_combination_443() {
        let macro = #filePermissions("rw-rwx-wx")
        let expected = FilePermissions(rawValue: 0o673)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-rwxr--")
    func permission_combination_444() {
        let macro = #filePermissions("rw-rwxr--")
        let expected = FilePermissions(rawValue: 0o674)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-rwxr-x")
    func permission_combination_445() {
        let macro = #filePermissions("rw-rwxr-x")
        let expected = FilePermissions(rawValue: 0o675)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-rwxrw-")
    func permission_combination_446() {
        let macro = #filePermissions("rw-rwxrw-")
        let expected = FilePermissions(rawValue: 0o676)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rw-rwxrwx")
    func permission_combination_447() {
        let macro = #filePermissions("rw-rwxrwx")
        let expected = FilePermissions(rawValue: 0o677)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx------")
    func permission_combination_448() {
        let macro = #filePermissions("rwx------")
        let expected = FilePermissions(rawValue: 0o700)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx-----x")
    func permission_combination_449() {
        let macro = #filePermissions("rwx-----x")
        let expected = FilePermissions(rawValue: 0o701)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx----w-")
    func permission_combination_450() {
        let macro = #filePermissions("rwx----w-")
        let expected = FilePermissions(rawValue: 0o702)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx----wx")
    func permission_combination_451() {
        let macro = #filePermissions("rwx----wx")
        let expected = FilePermissions(rawValue: 0o703)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx---r--")
    func permission_combination_452() {
        let macro = #filePermissions("rwx---r--")
        let expected = FilePermissions(rawValue: 0o704)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx---r-x")
    func permission_combination_453() {
        let macro = #filePermissions("rwx---r-x")
        let expected = FilePermissions(rawValue: 0o705)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx---rw-")
    func permission_combination_454() {
        let macro = #filePermissions("rwx---rw-")
        let expected = FilePermissions(rawValue: 0o706)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx---rwx")
    func permission_combination_455() {
        let macro = #filePermissions("rwx---rwx")
        let expected = FilePermissions(rawValue: 0o707)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx--x---")
    func permission_combination_456() {
        let macro = #filePermissions("rwx--x---")
        let expected = FilePermissions(rawValue: 0o710)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx--x--x")
    func permission_combination_457() {
        let macro = #filePermissions("rwx--x--x")
        let expected = FilePermissions(rawValue: 0o711)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx--x-w-")
    func permission_combination_458() {
        let macro = #filePermissions("rwx--x-w-")
        let expected = FilePermissions(rawValue: 0o712)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx--x-wx")
    func permission_combination_459() {
        let macro = #filePermissions("rwx--x-wx")
        let expected = FilePermissions(rawValue: 0o713)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx--xr--")
    func permission_combination_460() {
        let macro = #filePermissions("rwx--xr--")
        let expected = FilePermissions(rawValue: 0o714)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx--xr-x")
    func permission_combination_461() {
        let macro = #filePermissions("rwx--xr-x")
        let expected = FilePermissions(rawValue: 0o715)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx--xrw-")
    func permission_combination_462() {
        let macro = #filePermissions("rwx--xrw-")
        let expected = FilePermissions(rawValue: 0o716)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx--xrwx")
    func permission_combination_463() {
        let macro = #filePermissions("rwx--xrwx")
        let expected = FilePermissions(rawValue: 0o717)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx-w----")
    func permission_combination_464() {
        let macro = #filePermissions("rwx-w----")
        let expected = FilePermissions(rawValue: 0o720)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx-w---x")
    func permission_combination_465() {
        let macro = #filePermissions("rwx-w---x")
        let expected = FilePermissions(rawValue: 0o721)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx-w--w-")
    func permission_combination_466() {
        let macro = #filePermissions("rwx-w--w-")
        let expected = FilePermissions(rawValue: 0o722)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx-w--wx")
    func permission_combination_467() {
        let macro = #filePermissions("rwx-w--wx")
        let expected = FilePermissions(rawValue: 0o723)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx-w-r--")
    func permission_combination_468() {
        let macro = #filePermissions("rwx-w-r--")
        let expected = FilePermissions(rawValue: 0o724)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx-w-r-x")
    func permission_combination_469() {
        let macro = #filePermissions("rwx-w-r-x")
        let expected = FilePermissions(rawValue: 0o725)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx-w-rw-")
    func permission_combination_470() {
        let macro = #filePermissions("rwx-w-rw-")
        let expected = FilePermissions(rawValue: 0o726)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx-w-rwx")
    func permission_combination_471() {
        let macro = #filePermissions("rwx-w-rwx")
        let expected = FilePermissions(rawValue: 0o727)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx-wx---")
    func permission_combination_472() {
        let macro = #filePermissions("rwx-wx---")
        let expected = FilePermissions(rawValue: 0o730)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx-wx--x")
    func permission_combination_473() {
        let macro = #filePermissions("rwx-wx--x")
        let expected = FilePermissions(rawValue: 0o731)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx-wx-w-")
    func permission_combination_474() {
        let macro = #filePermissions("rwx-wx-w-")
        let expected = FilePermissions(rawValue: 0o732)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx-wx-wx")
    func permission_combination_475() {
        let macro = #filePermissions("rwx-wx-wx")
        let expected = FilePermissions(rawValue: 0o733)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx-wxr--")
    func permission_combination_476() {
        let macro = #filePermissions("rwx-wxr--")
        let expected = FilePermissions(rawValue: 0o734)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx-wxr-x")
    func permission_combination_477() {
        let macro = #filePermissions("rwx-wxr-x")
        let expected = FilePermissions(rawValue: 0o735)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx-wxrw-")
    func permission_combination_478() {
        let macro = #filePermissions("rwx-wxrw-")
        let expected = FilePermissions(rawValue: 0o736)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwx-wxrwx")
    func permission_combination_479() {
        let macro = #filePermissions("rwx-wxrwx")
        let expected = FilePermissions(rawValue: 0o737)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxr-----")
    func permission_combination_480() {
        let macro = #filePermissions("rwxr-----")
        let expected = FilePermissions(rawValue: 0o740)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxr----x")
    func permission_combination_481() {
        let macro = #filePermissions("rwxr----x")
        let expected = FilePermissions(rawValue: 0o741)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxr---w-")
    func permission_combination_482() {
        let macro = #filePermissions("rwxr---w-")
        let expected = FilePermissions(rawValue: 0o742)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxr---wx")
    func permission_combination_483() {
        let macro = #filePermissions("rwxr---wx")
        let expected = FilePermissions(rawValue: 0o743)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxr--r--")
    func permission_combination_484() {
        let macro = #filePermissions("rwxr--r--")
        let expected = FilePermissions(rawValue: 0o744)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxr--r-x")
    func permission_combination_485() {
        let macro = #filePermissions("rwxr--r-x")
        let expected = FilePermissions(rawValue: 0o745)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxr--rw-")
    func permission_combination_486() {
        let macro = #filePermissions("rwxr--rw-")
        let expected = FilePermissions(rawValue: 0o746)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxr--rwx")
    func permission_combination_487() {
        let macro = #filePermissions("rwxr--rwx")
        let expected = FilePermissions(rawValue: 0o747)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxr-x---")
    func permission_combination_488() {
        let macro = #filePermissions("rwxr-x---")
        let expected = FilePermissions(rawValue: 0o750)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxr-x--x")
    func permission_combination_489() {
        let macro = #filePermissions("rwxr-x--x")
        let expected = FilePermissions(rawValue: 0o751)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxr-x-w-")
    func permission_combination_490() {
        let macro = #filePermissions("rwxr-x-w-")
        let expected = FilePermissions(rawValue: 0o752)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxr-x-wx")
    func permission_combination_491() {
        let macro = #filePermissions("rwxr-x-wx")
        let expected = FilePermissions(rawValue: 0o753)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxr-xr--")
    func permission_combination_492() {
        let macro = #filePermissions("rwxr-xr--")
        let expected = FilePermissions(rawValue: 0o754)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxr-xr-x")
    func permission_combination_493() {
        let macro = #filePermissions("rwxr-xr-x")
        let expected = FilePermissions(rawValue: 0o755)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxr-xrw-")
    func permission_combination_494() {
        let macro = #filePermissions("rwxr-xrw-")
        let expected = FilePermissions(rawValue: 0o756)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxr-xrwx")
    func permission_combination_495() {
        let macro = #filePermissions("rwxr-xrwx")
        let expected = FilePermissions(rawValue: 0o757)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxrw----")
    func permission_combination_496() {
        let macro = #filePermissions("rwxrw----")
        let expected = FilePermissions(rawValue: 0o760)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxrw---x")
    func permission_combination_497() {
        let macro = #filePermissions("rwxrw---x")
        let expected = FilePermissions(rawValue: 0o761)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxrw--w-")
    func permission_combination_498() {
        let macro = #filePermissions("rwxrw--w-")
        let expected = FilePermissions(rawValue: 0o762)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxrw--wx")
    func permission_combination_499() {
        let macro = #filePermissions("rwxrw--wx")
        let expected = FilePermissions(rawValue: 0o763)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxrw-r--")
    func permission_combination_500() {
        let macro = #filePermissions("rwxrw-r--")
        let expected = FilePermissions(rawValue: 0o764)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxrw-r-x")
    func permission_combination_501() {
        let macro = #filePermissions("rwxrw-r-x")
        let expected = FilePermissions(rawValue: 0o765)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxrw-rw-")
    func permission_combination_502() {
        let macro = #filePermissions("rwxrw-rw-")
        let expected = FilePermissions(rawValue: 0o766)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxrw-rwx")
    func permission_combination_503() {
        let macro = #filePermissions("rwxrw-rwx")
        let expected = FilePermissions(rawValue: 0o767)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxrwx---")
    func permission_combination_504() {
        let macro = #filePermissions("rwxrwx---")
        let expected = FilePermissions(rawValue: 0o770)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxrwx--x")
    func permission_combination_505() {
        let macro = #filePermissions("rwxrwx--x")
        let expected = FilePermissions(rawValue: 0o771)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxrwx-w-")
    func permission_combination_506() {
        let macro = #filePermissions("rwxrwx-w-")
        let expected = FilePermissions(rawValue: 0o772)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxrwx-wx")
    func permission_combination_507() {
        let macro = #filePermissions("rwxrwx-wx")
        let expected = FilePermissions(rawValue: 0o773)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxrwxr--")
    func permission_combination_508() {
        let macro = #filePermissions("rwxrwxr--")
        let expected = FilePermissions(rawValue: 0o774)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxrwxr-x")
    func permission_combination_509() {
        let macro = #filePermissions("rwxrwxr-x")
        let expected = FilePermissions(rawValue: 0o775)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxrwxrw-")
    func permission_combination_510() {
        let macro = #filePermissions("rwxrwxrw-")
        let expected = FilePermissions(rawValue: 0o776)
        #expect(macro == expected)
    }

    @Test("Macro evaluate rwxrwxrwx")
    func permission_combination_511() {
        let macro = #filePermissions("rwxrwxrwx")
        let expected = FilePermissions(rawValue: 0o777)
        #expect(macro == expected)
    }

}
