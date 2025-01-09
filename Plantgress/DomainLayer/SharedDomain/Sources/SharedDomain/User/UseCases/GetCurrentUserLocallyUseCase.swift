//
//  GetCurrentUserLocallyUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 12.12.2024.
//

import Foundation

/// Protocol defining the use case for retrieving the current user's data locally.
public protocol GetCurrentUserLocallyUseCase {
    /// Executes the use case to retrieve the current user's data from local storage.
    /// - Returns: The `User` object representing the current user.
    /// - Throws: An error if the user's data cannot be retrieved or decoded.
    func execute() throws -> User
}

/// Implementation of the `GetCurrentUserLocallyUseCase` protocol for retrieving the current user's data locally.
public struct GetCurrentUserLocallyUseCaseImpl: GetCurrentUserLocallyUseCase {
     
    /// The repository for managing user data.
    private let userRepository: UserRepository
    
    /// Initializes a new instance of `GetCurrentUserLocallyUseCaseImpl`.
    /// - Parameter userRepository: The `UserRepository` for interacting with user-related data.
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    /// Executes the use case to retrieve the current user's data from local storage.
    /// - Returns: The `User` object representing the current user.
    /// - Throws: An error if the user's data cannot be retrieved or decoded.
    public func execute() throws -> User {
        return try userRepository.getLocalUser()
    }
}
