//
//  UserRepository.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 11.12.2024.
//

import Foundation

public protocol UserRepository {
    func isUserLoggedIn() -> Bool
    func getRemoteUser(id: String) async throws -> User
    func getLocalUser() throws -> User
    func createUser(_ user: User) async throws
    func saveUserLocally(user: User) throws
    func deleteCurrentUserLocally() throws
}
