//
//  SendPasswordResetUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 10.12.2024.
//

/// Protocol defining the use case for sending a password reset email.
public protocol SendPasswordResetUseCase {
    /// Executes the use case to send a password reset email to the specified email address.
    /// - Parameter email: The email address to send the password reset link to.
    /// - Throws: An error if the password reset process fails.
    func execute(email: String) async throws
}

/// Implementation of the `SendPasswordResetUseCase` protocol for sending a password reset email.
public struct SendPasswordResetUseCaseImpl: SendPasswordResetUseCase {
    
    /// The repository for accessing authentication-related data.
    private let authRepository: AuthRepository
    
    /// The repository for managing user data.
    private let userRepository: UserRepository
    
    /// Initializes a new instance of `SendPasswordResetUseCaseImpl`.
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
    
    /// Executes the use case to send a password reset email to the specified email address.
    /// - Parameter email: The email address to send the password reset link to.
    /// - Throws: An error if the password reset process fails.
    public func execute(email: String) async throws {
        // Save the email locally for persistence.
        try? userRepository.saveUserEmailLocally(email: email)
        
        // Send the password reset email via the authentication repository.
        try await authRepository.sendPasswordReset(email: email)
    }
}
