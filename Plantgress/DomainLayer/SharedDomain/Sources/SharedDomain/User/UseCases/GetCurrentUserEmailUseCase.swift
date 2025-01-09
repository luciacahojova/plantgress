//
//  GetCurrentUsersEmailUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 10.12.2024.
//

import Foundation

/// Protocol defining the use case for retrieving the current user's email address.
public protocol GetCurrentUsersEmailUseCase {
    /// Executes the use case to retrieve the current user's email address.
    /// - Returns: The email address of the current user, or `nil` if not available.
    func execute() -> String?
}

/// Implementation of the `GetCurrentUsersEmailUseCase` protocol for retrieving the current user's email address.
public struct GetCurrentUsersEmailUseCaseImpl: GetCurrentUsersEmailUseCase {
    
    /// The repository for managing user data.
    private let userRepository: UserRepository
    
    /// Initializes a new instance of `GetCurrentUsersEmailUseCaseImpl`.
    /// - Parameter userRepository: The `UserRepository` for interacting with user data.
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    /// Executes the use case to retrieve the current user's email address.
    /// - Returns: The email address of the current user, or `nil` if not available.
    public func execute() -> String? {
        return try? userRepository.getUserEmailLocally()
    }
}
