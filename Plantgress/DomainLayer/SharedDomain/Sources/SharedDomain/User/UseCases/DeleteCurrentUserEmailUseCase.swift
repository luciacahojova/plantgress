//
//  DeleteCurrentUserEmailUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 13.12.2024.
//

import Foundation

/// Protocol defining the use case for deleting the current user's email address locally.
public protocol DeleteCurrentUserEmailUseCase {
    /// Executes the use case to delete the user's email address locally.
    func execute()
}

/// Implementation of the `DeleteCurrentUserEmailUseCase` protocol for deleting the current user's email address locally.
public struct DeleteCurrentUserEmailUseCaseImpl: DeleteCurrentUserEmailUseCase {
    
    /// The repository for managing user data.
    private let userRepository: UserRepository
    
    /// Initializes a new instance of `DeleteCurrentUserEmailUseCaseImpl`.
    /// - Parameter userRepository: The `UserRepository` for interacting with user data.
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    /// Executes the use case to delete the user's email address locally.
    public func execute() {
        // Attempt to delete the email locally, handling any errors silently.
        try? userRepository.deleteUserEmailLocally()
    }
}
