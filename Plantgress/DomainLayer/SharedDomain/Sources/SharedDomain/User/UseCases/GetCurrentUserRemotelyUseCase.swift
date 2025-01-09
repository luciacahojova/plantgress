//
//  GetCurrentUserRemotelyUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 11.12.2024.
//

import Foundation

/// Protocol defining the use case for retrieving the current user's data remotely.
public protocol GetCurrentUserRemotelyUseCase {
    /// Executes the use case to retrieve the current user's data from a remote source.
    /// - Returns: The `User` object representing the current user.
    /// - Throws: `UserError.notFound` if the user ID cannot be retrieved or an error if the remote retrieval fails.
    func execute() async throws -> User
}

/// Implementation of the `GetCurrentUserRemotelyUseCase` protocol for retrieving the current user's data remotely.
public struct GetCurrentUserRemotelyUseCaseImpl: GetCurrentUserRemotelyUseCase {
    
    /// The repository for accessing authentication-related data.
    private let authRepository: AuthRepository
    
    /// The repository for managing user data.
    private let userRepository: UserRepository
    
    /// Initializes a new instance of `GetCurrentUserRemotelyUseCaseImpl`.
    /// - Parameters:
    ///   - authRepository: The `AuthRepository` for interacting with authentication data.
    ///   - userRepository: The `UserRepository` for managing user-related data.
    public init(
        authRepository: AuthRepository,
        userRepository: UserRepository
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
    /// Executes the use case to retrieve the current user's data from a remote source.
    /// - Returns: The `User` object representing the current user.
    /// - Throws: `UserError.notFound` if the user ID cannot be retrieved, or an error if the remote retrieval fails.
    public func execute() async throws -> User {
        // Retrieve the user ID from the authentication repository.
        guard let userId = authRepository.getUserId() else {
            throw UserError.notFound
        }
        
        // Fetch the user's data from the remote repository.
        return try await userRepository.getRemoteUser(id: userId)
    }
}
