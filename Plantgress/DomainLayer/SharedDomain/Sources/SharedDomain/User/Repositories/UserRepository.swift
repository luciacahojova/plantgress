//
//  UserRepository.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 11.12.2024.
//

import Foundation

public protocol UserRepository {
    func getUser(id: String) async throws -> User
    func createUser(_ user: User) async throws
}
