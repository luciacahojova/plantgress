//
//  FirebaseAuthProvider.swift
//  FirebaseAuthProvider
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import SharedDomain

public protocol FirebaseAuthProvider {
    func isUserLoggedIn() -> Bool
    func isEmailVerified() -> Bool
    func registerUser(credentials: RegistrationCredentials) async throws
    func sendEmailVerification() async throws
    func logInUser(credentials: LoginCredentials) async throws
    func logOutUser() throws
    func getUserEmail() -> String?
}
