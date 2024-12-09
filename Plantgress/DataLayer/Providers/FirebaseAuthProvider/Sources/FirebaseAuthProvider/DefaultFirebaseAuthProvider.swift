//
//  DefaultFirebaseAuthProvider.swift
//  FirebaseAuthProvider
//
//  Created by Lucia Cahojova on 08.12.2024.
//

import FirebaseAuth
import SharedDomain

public struct DefaultFirebaseAuthProvider {
    public init() {}
}

extension DefaultFirebaseAuthProvider: FirebaseAuthProvider {
    public func isUserLoggedIn() -> Bool {
        guard let user = Auth.auth().currentUser else { return false }
        return user.emailVerified()
    }
    
    public func registerUser(credentials: RegistrationCredentials) async throws {
        try await Auth.auth().createUser(withEmail: credentials.email, password: credentials.password)
    }
    
    public func sendEmailVerification() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        
        if user.isEmailVerified {
            throw AuthError.emailAlreadyVerified
        }
        
        try await user.sendEmailVerification()
    }
    
    public func logInUser(credentials: LoginCredentials) async throws {
        let user = try await Auth.auth().signIn(withEmail: credentials.email, password: credentials.password).user
        
        if !user.isEmailVerified {
            throw AuthError.userNotVerified
        }
    }
    
    public func logOutUser() throws {
        try Auth.auth().signOut()
    }
}
