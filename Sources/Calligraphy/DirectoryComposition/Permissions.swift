//
//  File 2.swift
//  Calligraphy
//
//  Created by Varun Santhanam on 4/12/25.
//

import Foundation

/// A type representing file permissions
public struct FilePermissions: OptionSet, Equatable, Hashable, Sendable {
    
    // MARK: - API
    
    public static let readUser    = FilePermissions(rawValue: 0o400)

    public static let writeUser   = FilePermissions(rawValue: 0o200)
    
    public static let executeUser = FilePermissions(rawValue: 0o100)

    public static let readGroup    = FilePermissions(rawValue: 0o040)
    
    public static let writeGroup   = FilePermissions(rawValue: 0o020)
    
    public static let executeGroup = FilePermissions(rawValue: 0o010)

    public static let readOther    = FilePermissions(rawValue: 0o004)
    
    public static let writeOther   = FilePermissions(rawValue: 0o002)
    
    public static let executeOther = FilePermissions(rawValue: 0o001)

    public static let executable: FilePermissions = [
        .default,
        .executeUser,
        .executeGroup,
        .executeOther
    ]
    
    public static let all: FilePermissions = [
        .readUser,
        .writeUser,
        .executeUser,
        .readGroup,
        .writeGroup,
        .executeGroup,
        .readOther,
        .writeOther,
        .executeOther
    ]
    
    public static let `default`: FilePermissions = [.readUser, .writeUser, .readGroup, .readOther]

    // MARK: - OptionSet
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public let rawValue: Int

}
