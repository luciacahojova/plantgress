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
}
