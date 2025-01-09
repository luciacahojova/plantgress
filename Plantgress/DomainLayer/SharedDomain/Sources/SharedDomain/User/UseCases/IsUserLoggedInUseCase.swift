//
//  IsUserLoggedInUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import Foundation

/// Protocol defining the use case for checking if a user is logged in.
public protocol IsUserLoggedInUseCase {
    /// Executes the use case to determine if a user is logged in.
    /// - Returns: A Boolean indicating whether a user is currently logged in.
    func execute() -> Bool
}

/// Implementation of the `IsUserLoggedInUseCase` protocol for determining if a user is logged in.
public struct IsUserLoggedInUseCaseImpl: IsUserLoggedInUseCase {
    
    /// The repository for accessing user-related data.
    private let userRepository: UserRepository
    
    /// Initializes a new instance of `IsUserLoggedInUseCaseImpl`.
    /// - Parameter userRepository: The `UserRepository` for interacting with user data.
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    /// Executes the use case to determine if a user is logged in.
    /// - Returns: A Boolean indicating whether a user is currently logged in.
    public func execute() -> Bool {
        return userRepository.isUserLoggedIn()
    }
}
