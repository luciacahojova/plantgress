//
//  UserRepository.swift
//  UserToolkit
//
//  Created by Lucia Cahojova on 11.12.2024.
//

import FirebaseFirestoreProvider
import SharedDomain
import Utilities

public struct UserRepositoryImpl: UserRepository {
    
    private let firebaseFirestoreProvider: FirebaseFirestoreProvider
    
    public init(firebaseFirestoreProvider: FirebaseFirestoreProvider) {
        self.firebaseFirestoreProvider = firebaseFirestoreProvider
    }
    
    public func getUser(id: String) async throws -> User {
        try await self.firebaseFirestoreProvider.get(
            path: DatabaseConstants.usersCollection,
            id: id,
            as: User.self
        )
    }
    
    public func createUser(_ user: User) async throws {
        try await firebaseFirestoreProvider.update(
            path: DatabaseConstants.usersCollection,
            id: user.id,
            data: user
        )
    }
}
