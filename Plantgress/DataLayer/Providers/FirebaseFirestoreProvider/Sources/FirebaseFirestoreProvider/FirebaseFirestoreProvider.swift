//
//  FirebaseFirestoreProvider.swift
//  FirebaseFirestoreProvider
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import SharedDomain

public protocol FirebaseFirestoreProvider {
    func getUser(id: String) async throws -> User
    func createUser(_ user: User) async throws
}
