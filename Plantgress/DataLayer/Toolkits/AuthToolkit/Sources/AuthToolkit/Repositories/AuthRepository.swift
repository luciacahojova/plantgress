//
//  AuthRepository.swift
//  AuthToolkit
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import FirebaseAuthProvider
import SharedDomain

public struct AuthRepositoryImpl: AuthRepository {
    private let firebaseAuthProvider: FirebaseAuthProvider
    
    public init(
        firebaseAuthProvider: FirebaseAuthProvider
    ) {
        self.firebaseAuthProvider = firebaseAuthProvider
    }
    
    public func isUserLoggedIn() -> Bool {
        firebaseAuthProvider.isUserLoggedIn()
    }
    
    public func isEmailVerified() -> Bool {
        firebaseAuthProvider.isEmailVerified()
    }
    
    public func registerUser(credentials: RegistrationCredentials) async throws {
        try await firebaseAuthProvider.registerUser(credentials: credentials)
    }
    
    public func sendEmailVerification() async throws {
        try await firebaseAuthProvider.sendEmailVerification()
    }
    
    public func logInUser(credentials: LoginCredentials) async throws {
        try await firebaseAuthProvider.logInUser(credentials: credentials)
    }
    
    public func logOutUser() throws {
        try firebaseAuthProvider.logOutUser()
    }
    
    public func getUserEmail() -> String? {
        firebaseAuthProvider.getUserEmail()
    }
    
    public func sendPasswordReset(email: String) async throws {
        try await firebaseAuthProvider.sendPasswordReset(email: email)
    }
}
