//
//  UserRepository.swift
//  UserToolkit
//
//  Created by Lucia Cahojova on 11.12.2024.
//

import FirebaseFirestoreProvider
import KeychainProvider
import SharedDomain
import Utilities
import Foundation

/// Implementation of the `UserRepository` protocol for managing user data, both locally and remotely.
public struct UserRepositoryImpl: UserRepository {
    
    /// Firebase Firestore provider for remote database operations.
    private let firebaseFirestoreProvider: FirebaseFirestoreProvider
    
    /// Keychain provider for securely storing local user data.
    private let keychainProvider: KeychainProvider
    
    /// Initializes a new instance of `UserRepositoryImpl`.
    /// - Parameters:
    ///   - firebaseFirestoreProvider: The Firestore provider for remote operations.
    ///   - keychainProvider: The Keychain provider for secure local storage.
    public init(
        firebaseFirestoreProvider: FirebaseFirestoreProvider,
        keychainProvider: KeychainProvider
    ) {
        self.firebaseFirestoreProvider = firebaseFirestoreProvider
        self.keychainProvider = keychainProvider
    }
    
    /// Retrieves a user from the remote database by ID.
    /// - Parameter id: The unique identifier of the user.
    /// - Returns: The `User` object retrieved from the database.
    /// - Throws: An error if the retrieval fails.
    public func getRemoteUser(id: String) async throws -> User {
        try await self.firebaseFirestoreProvider.get(
            path: DatabaseConstants.usersCollection,
            id: id,
            as: User.self
        )
    }
    
    /// Retrieves the currently stored local user.
    /// - Returns: The `User` object stored locally.
    /// - Throws: An error if the local user cannot be retrieved or decoded.
    public func getLocalUser() throws -> User {
        let userJsonString = try keychainProvider.read(.user)
        guard let userJson = userJsonString.data(using: .utf8) else { throw UserError.persistenceError }
        let user = try JSONDecoder().decode(User.self, from: userJson)
        
        return user
    }
    
    /// Saves a user object locally in the keychain.
    /// - Parameter user: The `User` object to store locally.
    /// - Throws: An error if the user cannot be encoded or stored.
    public func saveUserLocally(user: User) throws {
        let userJson = try JSONEncoder().encode(user)
        guard let userJsonString = String(data: userJson, encoding: .utf8) else { throw UserError.persistenceError }
        try keychainProvider.update(.user, value: userJsonString)
    }

    /// Creates or updates a user in the remote database.
    /// - Parameter user: The `User` object to create or update.
    /// - Throws: An error if the operation fails.
    public func createUser(_ user: User) async throws {
        try await firebaseFirestoreProvider.update(
            path: DatabaseConstants.usersCollection,
            id: user.id,
            data: user
        )
    }
    
    /// Deletes the currently stored local user data.
    /// - Throws: An error if the operation fails.
    public func deleteCurrentUserLocally() throws {
        try keychainProvider.delete(.user)
    }
    
    /// Deletes a user from the remote database by ID.
    /// - Parameter userId: The unique identifier of the user to delete.
    /// - Throws: An error if the deletion fails.
    public func deleteUser(userId: String) async throws {
        try await firebaseFirestoreProvider.delete(
            path: DatabaseConstants.usersCollection,
            id: userId
        )
        
        try? keychainProvider.delete(.user)
    }
    
    /// Checks if a user is currently logged in locally.
    /// - Returns: A Boolean indicating whether a user is logged in.
    public func isUserLoggedIn() -> Bool {
        do {
            let userJsonString = try keychainProvider.read(.user)
            guard let userJson = userJsonString.data(using: .utf8) else { throw UserError.persistenceError }
            
            return true
        } catch {
            return false
        }
    }
    
    /// Retrieves the locally stored user email.
    /// - Returns: The email address of the user.
    /// - Throws: An error if the email cannot be retrieved.
    public func getUserEmailLocally() throws -> String {
        try keychainProvider.read(.userEmail)
    }
    
    /// Saves a user's email locally in the keychain.
    /// - Parameter email: The email address to store locally.
    /// - Throws: An error if the email cannot be stored.
    public func saveUserEmailLocally(email: String) throws {
        try keychainProvider.update(.userEmail, value: email)
    }
    
    /// Deletes the locally stored user email.
    /// - Throws: An error if the email cannot be deleted.
    public func deleteUserEmailLocally() throws {
        try keychainProvider.delete(.userEmail)
    }
}
