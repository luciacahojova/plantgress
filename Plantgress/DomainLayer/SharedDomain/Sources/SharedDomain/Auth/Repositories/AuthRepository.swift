//
//  AuthRepository.swift
//  SharedDomain
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import Foundation

public protocol AuthRepository {
    func isEmailVerified() -> Bool
    func registerUser(credentials: RegistrationCredentials) async throws -> String
    func sendEmailVerification() async throws
    func logInUser(credentials: LoginCredentials) async throws
    func logOutUser() throws
    func getUserEmail() -> String?
    func getUserId() -> String?
    func sendPasswordReset(email: String) async throws
}
