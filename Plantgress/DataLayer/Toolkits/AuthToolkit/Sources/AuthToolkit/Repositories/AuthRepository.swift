//
//  AuthRepository.swift
//  AuthToolkit
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import FirebaseAuthProvider
import SharedDomain

/// Implementation of the `AuthRepository` protocol for managing user authentication.
public struct AuthRepositoryImpl: AuthRepository {
    /// Firebase Authentication provider for handling authentication operations.
    private let firebaseAuthProvider: FirebaseAuthProvider
    
    /// Initializes a new instance of `AuthRepositoryImpl`.
    /// - Parameter firebaseAuthProvider: The Firebase Authentication provider for authentication-related operations.
    public init(
        firebaseAuthProvider: FirebaseAuthProvider
    ) {
        self.firebaseAuthProvider = firebaseAuthProvider
    }
    
    /// Checks if the user's email is verified.
    /// - Returns: A Boolean indicating whether the email is verified.
    public func isEmailVerified() -> Bool {
        firebaseAuthProvider.isEmailVerified()
    }
    
    /// Registers a new user with the provided credentials.
    /// - Parameter credentials: The user's registration credentials.
    /// - Returns: The unique identifier of the registered user.
    /// - Throws: An error if the registration fails.
    public func registerUser(credentials: RegistrationCredentials) async throws -> String {
        try await firebaseAuthProvider.registerUser(credentials: credentials)
    }
    
    /// Sends a verification email to the user's email address.
    /// - Throws: An error if the email verification process fails.
    public func sendEmailVerification() async throws {
        try await firebaseAuthProvider.sendEmailVerification()
    }
    
    /// Logs in a user with the provided credentials.
    /// - Parameter credentials: The user's login credentials.
    /// - Throws: An error if the login process fails.
    public func logInUser(credentials: LoginCredentials) async throws {
        try await firebaseAuthProvider.logInUser(credentials: credentials)
    }
    
    /// Logs out the currently logged-in user.
    /// - Throws: An error if the logout process fails.
    public func logOutUser() throws {
        try firebaseAuthProvider.logOutUser()
    }
    
    /// Retrieves the email address of the currently logged-in user.
    /// - Returns: The email address of the user, or `nil` if no user is logged in.
    public func getUserEmail() -> String? {
        firebaseAuthProvider.getUserEmail()
    }
    
    /// Retrieves the unique identifier of the currently logged-in user.
    /// - Returns: The user ID, or `nil` if no user is logged in.
    public func getUserId() -> String? {
        firebaseAuthProvider.getUserId()
    }
    
    /// Deletes the currently logged-in user from the authentication system.
    public func deleteUser() {
        firebaseAuthProvider.deleteUser()
    }
    
    /// Sends a password reset email to the specified email address.
    /// - Parameter email: The email address to send the password reset link to.
    /// - Throws: An error if the password reset process fails.
    public func sendPasswordReset(email: String) async throws {
        try await firebaseAuthProvider.sendPasswordReset(email: email)
    }
}
