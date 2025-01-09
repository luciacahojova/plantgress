//
//  FirebaseAuthProvider.swift
//  FirebaseAuthProvider
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import SharedDomain

/// Protocol defining operations for interacting with Firebase Authentication.
public protocol FirebaseAuthProvider {
    /// Checks if the currently logged-in user's email is verified.
    /// - Returns: A Boolean indicating whether the email is verified.
    func isEmailVerified() -> Bool
    
    /// Registers a new user with the provided credentials.
    /// - Parameter credentials: The user's registration credentials, encapsulated in `RegistrationCredentials`.
    /// - Returns: The unique identifier of the registered user as a `String`.
    /// - Throws: An error if the registration process fails.
    func registerUser(credentials: RegistrationCredentials) async throws -> String
    
    /// Sends a verification email to the currently logged-in user.
    /// - Throws: An error if the email verification process fails.
    func sendEmailVerification() async throws
    
    /// Logs in a user with the provided credentials.
    /// - Parameter credentials: The user's login credentials, encapsulated in `LoginCredentials`.
    /// - Throws: An error if the login process fails.
    func logInUser(credentials: LoginCredentials) async throws
    
    /// Logs out the currently logged-in user.
    /// - Throws: An error if the logout process fails.
    func logOutUser() throws
    
    /// Retrieves the email address of the currently logged-in user.
    /// - Returns: The user's email address as a `String`, or `nil` if no user is logged in.
    func getUserEmail() -> String?
    
    /// Retrieves the unique identifier of the currently logged-in user.
    /// - Returns: The user's ID as a `String`, or `nil` if no user is logged in.
    func getUserId() -> String?
    
    /// Deletes the currently logged-in user's account.
    func deleteUser()
    
    /// Sends a password reset email to the specified email address.
    /// - Parameter email: The email address to send the password reset link to.
    /// - Throws: An error if the password reset process fails.
    func sendPasswordReset(email: String) async throws
}
