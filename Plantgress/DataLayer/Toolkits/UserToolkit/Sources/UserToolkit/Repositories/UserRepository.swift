//
//  UserRepository.swift
//  UserToolkit
//
//  Created by Lucia Cahojova on 11.12.2024.
//

import FirebaseFirestoreProvider
import SharedDomain

public struct UserRepositoryImpl: UserRepository {
    
    private let firebaseFirestoreProvider: FirebaseFirestoreProvider
    
    public init(firebaseFirestoreProvider: FirebaseFirestoreProvider) {
        self.firebaseFirestoreProvider = firebaseFirestoreProvider
    }
    
    public func getUser() -> User { // TODO
        User(
            id: "",
            email: "",
            name: "",
            surname: ""
        )
    }
    
    public func createUser(_ user: User) async throws {
        try await self.firebaseFirestoreProvider.createUser(user)
    }
}
