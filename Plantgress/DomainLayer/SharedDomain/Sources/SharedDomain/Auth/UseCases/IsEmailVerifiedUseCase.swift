//
//  IsEmailVerifiedUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 10.12.2024.
//

import Foundation

/// Protocol defining the use case for checking if the user's email is verified.
public protocol IsEmailVerifiedUseCase {
    /// Executes the use case to determine if the user's email is verified.
    /// - Returns: A Boolean indicating whether the email is verified.
    func execute() -> Bool
}

/// Implementation of the `IsEmailVerifiedUseCase` protocol for checking email verification status.
public struct IsEmailVerifiedUseCaseImpl: IsEmailVerifiedUseCase {
    
    /// The repository for accessing authentication-related data.
    private let authRepository: AuthRepository
    
    /// Initializes a new instance of `IsEmailVerifiedUseCaseImpl`.
    /// - Parameter authRepository: The `AuthRepository` for interacting with authentication data.
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    /// Executes the use case to determine if the user's email is verified.
    /// - Returns: A Boolean indicating whether the email is verified.
    public func execute() -> Bool {
        return authRepository.isEmailVerified()
    }
}
