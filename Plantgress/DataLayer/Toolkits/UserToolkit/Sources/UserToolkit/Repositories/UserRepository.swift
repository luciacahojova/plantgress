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

public struct UserRepositoryImpl: UserRepository {
    
    private let firebaseFirestoreProvider: FirebaseFirestoreProvider
    private let keychainProvider: KeychainProvider
    
    public init(
        firebaseFirestoreProvider: FirebaseFirestoreProvider,
        keychainProvider: KeychainProvider
    ) {
        self.firebaseFirestoreProvider = firebaseFirestoreProvider
        self.keychainProvider = keychainProvider
    }
    
    public func getRemoteUser(id: String) async throws -> User {
        try await self.firebaseFirestoreProvider.get(
            path: DatabaseConstants.usersCollection,
            id: id,
            as: User.self
        )
    }
    
    public func getLocalUser() throws -> User {
        let userJsonString = try keychainProvider.read(.user)
        guard let userJson = userJsonString.data(using: .utf8) else { throw UserError.persistenceError }
        let user = try JSONDecoder().decode(User.self, from: userJson)
        
        return user
    }
    
    public func saveUserLocally(user: User) throws {
        let userJson = try JSONEncoder().encode(user)
        guard let userJsonString = String(data: userJson, encoding: .utf8) else { throw UserError.persistenceError }
        try keychainProvider.update(.user, value: userJsonString)
    }

    public func createUser(_ user: User) async throws {
        try await firebaseFirestoreProvider.update(
            path: DatabaseConstants.usersCollection,
            id: user.id,
            data: user
        )
    }
    
    public func deleteCurrentUserLocally() throws {
        try keychainProvider.delete(.user)
    }
    
    public func deleteUser(userId: String) async throws {
        try await firebaseFirestoreProvider.delete(
            path: DatabaseConstants.usersCollection,
            id: userId
        )
        
        try? keychainProvider.delete(.user)
    }
    
    public func isUserLoggedIn() -> Bool {
        do {
            let userJsonString = try keychainProvider.read(.user)
            guard let userJson = userJsonString.data(using: .utf8) else { throw UserError.persistenceError }
            
            return true
        } catch {
            return false
        }
    }
    
    public func getUserEmailLocally() throws -> String {
        try keychainProvider.read(.userEmail)
    }
    
    public func saveUserEmailLocally(email: String) throws {
        try keychainProvider.update(.userEmail, value: email)
    }
    
    public func deleteUserEmailLocally() throws {
        try keychainProvider.delete(.userEmail)
    }
}
