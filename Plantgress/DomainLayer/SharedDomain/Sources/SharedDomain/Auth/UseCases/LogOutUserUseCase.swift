//
//  LogOutUserUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 12.12.2024.
//

/// Protocol defining the use case for logging out a user.
public protocol LogOutUserUseCase {
    /// Executes the use case to log out the user.
    /// - Throws: An error if the logout process fails.
    func execute() throws
}

/// Implementation of the `LogOutUserUseCase` protocol for logging out a user.
public struct LogOutUserUseCaseImpl: LogOutUserUseCase {
    
    /// The repository for managing user data.
    private let userRepository: UserRepository
    
    /// Initializes a new instance of `LogOutUserUseCaseImpl`.
    /// - Parameter userRepository: The `UserRepository` for interacting with user data.
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    /// Executes the use case to log out the user by deleting their local data.
    /// - Throws: An error if the process of deleting local user data fails.
    public func execute() throws {
        // Delete the current user's local data.
        try userRepository.deleteCurrentUserLocally()
        
        // Delete the locally stored user email.
        try? userRepository.deleteUserEmailLocally()
    }
}
