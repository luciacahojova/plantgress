//
//  FirebaseAuthProvider.swift
//  FirebaseAuthProvider
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import SharedDomain

public protocol FirebaseAuthProvider {
    func isEmailVerified() -> Bool
    func registerUser(credentials: RegistrationCredentials) async throws -> String
    func sendEmailVerification() async throws
    func logInUser(credentials: LoginCredentials) async throws
    func logOutUser() throws
    func getUserEmail() -> String?
    func getUserId() -> String?
    func deleteUser()
    func sendPasswordReset(email: String) async throws
}
