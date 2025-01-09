//
//  RegisterUserUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 09.12.2024.
//

/// Protocol defining the use case for registering a new user.
public protocol RegisterUserUseCase {
    /// Executes the use case to register a new user with the provided credentials.
    /// - Parameter credentials: The user's registration credentials, encapsulated in `RegistrationCredentials`.
    /// - Throws: An error if the registration process fails.
    func execute(credentials: RegistrationCredentials) async throws
}

/// Implementation of the `RegisterUserUseCase` protocol for registering a new user.
public struct RegisterUserUseCaseImpl: RegisterUserUseCase {
    
    /// The repository for accessing authentication-related data.
    private let authRepository: AuthRepository
    
    /// The repository for managing user data.
    private let userRepository: UserRepository
    
    /// Initializes a new instance of `RegisterUserUseCaseImpl`.
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
    
    /// Executes the use case to register a new user with the provided credentials.
    /// - Parameter credentials: The user's registration credentials, encapsulated in `RegistrationCredentials`.
    /// - Throws: An error if the registration or user creation process fails.
    public func execute(credentials: RegistrationCredentials) async throws {
        // Save the user's email locally for persistence.
        try? userRepository.saveUserEmailLocally(email: credentials.email)
        
        // Register the user with the authentication system and retrieve their user ID.
        let userId = try await authRepository.registerUser(credentials: credentials)
        
        // Create a new `User` object with the registered details.
        let user = User(
            id: userId,
            email: credentials.email,
            name: credentials.name,
            surname: credentials.surname
        )
        
        // Save the new user in the user repository.
        try await userRepository.createUser(user)
    }
}
