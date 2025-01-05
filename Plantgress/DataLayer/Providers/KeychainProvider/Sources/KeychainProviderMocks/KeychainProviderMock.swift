//
//  KeychainProviderMock.swift
//  KeychainProvider
//
//  Created by Lucia Cahojova on 12.12.2024.
//

import KeychainProvider

public class KeychainProviderMock: KeychainProvider {
    
    private var data: [String: String] = [:]
    
    public init() {}

    func add(_ key: KeychainCoding, value: String) throws {
        data[key.rawValue] = value
    }

    public func read(_ key: KeychainCoding) throws -> String {
        guard let value = data[key.rawValue] else {
            throw KeychainError.valueForKeyNotFound
        }
        return value
    }

    public func delete(_ key: KeychainCoding) throws {
        data[key.rawValue] = nil
    }

    public func deleteAll() throws {
        data.removeAll()
    }

    public func deleteAll(except items: [KeychainCoding]?) throws {
        let items = items ?? []
        
        let keysToRemove = data.keys.filter { !items.contains(KeychainCoding(rawValue: $0)!) }
        for key in keysToRemove {
            data[key] = nil
        }
    }
    
    public func update(_ key: KeychainCoding, value: String) throws {
        data[key.rawValue] = value
    }
}
