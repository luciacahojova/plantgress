//
//  SystemKeychainProvider.swift
//  KeychainProvider
//
//  Created by Lucia Cahojova on 12.12.2024.
//

import Foundation
import KeychainAccess

public struct SystemKeychainProvider: KeychainProvider {
    public init() {}
    
    public func read(_ key: KeychainCoding) throws -> String {
        guard let bundleId = Bundle.app.bundleIdentifier else {
            print("❗️ READ: Invalid Bundle Identifier")
            throw KeychainError.invalidBundleIdentifier
        }
        let keychain = Keychain(service: bundleId, accessGroup: "group.\(bundleId)")
        
        guard let value = keychain[key.rawValue] else {
            print("❗️ READ: Value for \(key.rawValue) not found")
            throw KeychainError.valueForKeyNotFound
        }
        
        print("🔐 READ: \(key.rawValue) = \(value)")
        return value
    }
    
    public func update(_ key: KeychainCoding, value: String) throws {
        guard let bundleId = Bundle.app.bundleIdentifier else {
            print("❗️ UPDATE: Invalid Bundle Identifier")
            throw KeychainError.invalidBundleIdentifier
        }
        
        let keychain = Keychain(service: bundleId, accessGroup: "group.\(bundleId)")
        keychain[key.rawValue] = value
        print("🔐 UPDATE: \(key.rawValue) updated to \(value)")
    }
    
    public func delete(_ key: KeychainCoding) throws {
        guard let bundleId = Bundle.app.bundleIdentifier else {
            print("❗️ DELETE: Invalid Bundle Identifier")
            throw KeychainError.invalidBundleIdentifier
        }
        
        let keychain = Keychain(service: bundleId, accessGroup: "group.\(bundleId)")
        
        do {
            try keychain.remove(key.rawValue)
            print("🔐 DELETE: \(key.rawValue) removed")
        } catch {
            print("❗️ DELETE: Failed to remove \(key.rawValue) - \(error.localizedDescription)")
            throw KeychainError.default
        }
    }
    
    public func deleteAll() throws {
        for key in KeychainCoding.allCases {
            do {
                try delete(key)
            } catch {
                print("❗️ DELETE ALL: Failed to remove \(key.rawValue) - \(error.localizedDescription)")
                throw KeychainError.default
            }
        }
        print("🔐  DELETE ALL: All keys removed")
    }
    
    public func deleteAll(except items: [KeychainCoding]? = nil) throws {
        for key in KeychainCoding.allCases {
            if let items, items.contains(key) { continue }
            do {
                try delete(key)
            } catch {
                print("❗️ DELETE ALL EXCEPT: Failed to remove \(key.rawValue) - \(error.localizedDescription)")
                throw KeychainError.default
            }
        }
        print("🔐  DELETE ALL EXCEPT: Removed all keys except specified")
    }
}
