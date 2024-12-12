//
//  KeychainProvider.swift
//  KeychainProvider
//
//  Created by Lucia Cahojova on 12.12.2024.
//

import Foundation

public enum KeychainCoding: String, CaseIterable {
    case hasUserSeenAppPromo
    case user
}

public protocol KeychainProvider {
    func read(_ key: KeychainCoding) throws -> String
    func update(_ key: KeychainCoding, value: String) throws
    func delete(_ key: KeychainCoding) throws
    func deleteAll() throws
    func deleteAll(except items: [KeychainCoding]?) throws
}
