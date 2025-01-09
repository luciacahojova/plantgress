//
//  SaveCurrentUserEmailUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 13.12.2024.
//

import Foundation

/// Protocol defining the use case for saving the current user's email address locally.
public protocol SaveCurrentUserEmailUseCase {
    /// Executes the use case to save the user's email address locally.
    /// - Parameter email: The email address to save.
    func execute(email: String)
}

/// Implementation of the `SaveCurrentUserEmailUseCase` protocol for saving the current user's email address locally.
public struct SaveCurrentUserEmailUseCaseImpl: SaveCurrentUserEmailUseCase {
    
    /// The repository for managing user data.
    private let userRepository: UserRepository
    
    /// Initializes a new instance of `SaveCurrentUserEmailUseCaseImpl`.
    /// - Parameter userRepository: The `UserRepository` for interacting with user data.
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    /// Executes the use case to save the user's email address locally.
    /// - Parameter email: The email address to save.
    public func execute(email: String) {
        // Attempt to save the email locally, handling any errors silently.
        try? userRepository.saveUserEmailLocally(email: email)
    }
}
