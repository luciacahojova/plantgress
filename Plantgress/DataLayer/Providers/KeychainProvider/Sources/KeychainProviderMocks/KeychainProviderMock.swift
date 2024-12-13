//
//  KeychainProviderMock.swift
//  KeychainProvider
//
//  Created by Lucia Cahojova on 12.12.2024.
//

import Foundation

class KeychainProviderMock: KeychainProvider {
    private var data: [String: String] = [:]

    func add(_ key: KeychainCoding, value: String) throws {
        data[key.rawValue] = value
    }

    func read(_ key: KeychainCoding) throws -> String {
        guard let value = data[key.rawValue] else {
            throw KeychainError.valueForKeyNotFound
        }
        return value
    }

    func delete(_ key: KeychainCoding) throws {
        data[key.rawValue] = nil
    }

    func deleteAll() throws {
        data.removeAll()
    }

    func deleteAll(except values: [KeychainCoding]) throws {
        let keysToRemove = data.keys.filter { !values.contains(KeychainCoding(rawValue: $0)!) }
        for key in keysToRemove {
            data[key] = nil
        }
    }
}
