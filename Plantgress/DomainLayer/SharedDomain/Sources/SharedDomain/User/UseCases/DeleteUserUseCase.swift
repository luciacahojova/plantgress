//
//  DeleteUserUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 12.12.2024.
//

import Foundation

/// Protocol defining the use case for deleting a user.
public protocol DeleteUserUseCase {
    /// Executes the use case to delete a user by their ID.
    /// - Parameter userId: The unique identifier of the user to delete.
    /// - Throws: An error if the deletion process fails.
    func execute(userId: String) async throws
}

/// Implementation of the `DeleteUserUseCase` protocol for deleting a user.
public struct DeleteUserUseCaseImpl: DeleteUserUseCase {
    
    /// The repository for accessing authentication-related data.
    private let authRepository: AuthRepository
    
    /// The repository for managing user data.
    private let userRepository: UserRepository
    
    /// Initializes a new instance of `DeleteUserUseCaseImpl`.
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
    
    /// Executes the use case to delete a user by their ID.
    /// - Parameter userId: The unique identifier of the user to delete.
    /// - Throws: An error if the deletion process fails.
    public func execute(userId: String) async throws {
        // Delete the user account from the authentication system.
        authRepository.deleteUser()
        
        // Delete the user data from the remote repository.
        try await userRepository.deleteUser(userId: userId)
        
        // Delete the user's email locally, if it exists.
        try? userRepository.deleteUserEmailLocally()
    }
}
