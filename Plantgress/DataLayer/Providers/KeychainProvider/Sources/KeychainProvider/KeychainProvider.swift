//
//  KeychainProvider.swift
//  KeychainProvider
//
//  Created by Lucia Cahojova on 12.12.2024.
//

import Foundation

/// Enum representing the keys used for storing data in the keychain.
public enum KeychainCoding: String, CaseIterable {
    /// Key for storing whether the user has seen the app promotion.
    case hasUserSeenAppPromo
    /// Key for storing user information.
    case user
    /// Key for storing the user's email address.
    case userEmail
}

/// Protocol defining the operations for interacting with the keychain.
public protocol KeychainProvider {
    /// Reads a value from the keychain for the specified key.
    /// - Parameter key: The `KeychainCoding` key to read the value for.
    /// - Returns: The value associated with the key as a `String`.
    /// - Throws: An error if the read operation fails.
    func read(_ key: KeychainCoding) throws -> String
    
    /// Updates or creates a value in the keychain for the specified key.
    /// - Parameters:
    ///   - key: The `KeychainCoding` key to update or create.
    ///   - value: The value to associate with the key as a `String`.
    /// - Throws: An error if the update operation fails.
    func update(_ key: KeychainCoding, value: String) throws
    
    /// Deletes a value from the keychain for the specified key.
    /// - Parameter key: The `KeychainCoding` key to delete.
    /// - Throws: An error if the delete operation fails.
    func delete(_ key: KeychainCoding) throws
    
    /// Deletes all values from the keychain.
    /// - Throws: An error if the operation fails.
    func deleteAll() throws
    
    /// Deletes all values from the keychain except the specified items.
    /// - Parameter items: An optional array of `KeychainCoding` keys to exclude from deletion.
    /// - Throws: An error if the operation fails.
    func deleteAll(except items: [KeychainCoding]?) throws
}
