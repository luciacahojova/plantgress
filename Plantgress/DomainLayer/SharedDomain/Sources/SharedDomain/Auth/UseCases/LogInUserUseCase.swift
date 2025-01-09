//
//  LogInUserUseCase.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 09.12.2024.
//

/// Protocol defining the use case for logging in a user.
public protocol LogInUserUseCase {
    /// Executes the use case to log in a user with the provided credentials.
    /// - Parameter credentials: The user's login credentials, encapsulated in `LoginCredentials`.
    /// - Throws: An error if the login process fails.
    func execute(credentials: LoginCredentials) async throws
}

/// Implementation of the `LogInUserUseCase` protocol for logging in a user.
public struct LogInUserUseCaseImpl: LogInUserUseCase {
    
    /// The repository for accessing authentication-related data.
    private let authRepository: AuthRepository
    
    /// The repository for managing user data.
    private let userRepository: UserRepository
    
    /// Initializes a new instance of `LogInUserUseCaseImpl`.
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
    
    /// Executes the use case to log in a user with the provided credentials.
    /// - Parameter credentials: The user's login credentials, encapsulated in `LoginCredentials`.
    /// - Throws: An error if the login process fails or the user data cannot be retrieved.
    public func execute(credentials: LoginCredentials) async throws {
        // Save the user's email locally for persistence.
        try? userRepository.saveUserEmailLocally(email: credentials.email)
        
        // Log the user in via the authentication repository.
        try await authRepository.logInUser(credentials: credentials)
        
        // Retrieve the logged-in user's ID.
        guard let userId = authRepository.getUserId() else {
            throw UserError.notFound
        }
        
        // Fetch the user's data from the remote repository.
        let user = try await userRepository.getRemoteUser(id: userId)
        
        // Save the user's data locally.
        try userRepository.saveUserLocally(user: user)
    }
}
