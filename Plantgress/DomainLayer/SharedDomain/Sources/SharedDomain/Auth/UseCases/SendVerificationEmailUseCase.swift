//
//  SendVerificationEmailUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 09.12.2024.
//

/// Protocol defining the use case for sending a verification email to the user.
public protocol SendEmailVerificationUseCase {
    /// Executes the use case to send a verification email.
    /// - Throws: An error if the email verification process fails.
    func execute() async throws
}

/// Implementation of the `SendEmailVerificationUseCase` protocol for sending a verification email.
public struct SendEmailVerificationUseCaseImpl: SendEmailVerificationUseCase {
    
    /// The repository for accessing authentication-related data.
    private let authRepository: AuthRepository
    
    /// Initializes a new instance of `SendEmailVerificationUseCaseImpl`.
    /// - Parameter authRepository: The `AuthRepository` for interacting with authentication data.
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    /// Executes the use case to send a verification email.
    /// - Throws: An error if the email verification process fails.
    public func execute() async throws {
        try await authRepository.sendEmailVerification()
    }
}
