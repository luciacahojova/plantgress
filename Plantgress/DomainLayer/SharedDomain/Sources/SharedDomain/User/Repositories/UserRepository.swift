//
//  UserRepository.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 11.12.2024.
//

import Foundation

public protocol UserRepository {
    func isUserLoggedIn() -> Bool
    func getUserEmailLocally() throws -> String
    func deleteUserEmailLocally() throws
    func saveUserEmailLocally(email: String) throws
    func getRemoteUser(id: String) async throws -> User
    func getLocalUser() throws -> User
    func createUser(_ user: User) async throws
    func saveUserLocally(user: User) throws
    func deleteCurrentUserLocally() throws
    func deleteUser(userId: String) async throws
}
