//
//  DefaultFirebaseAuthProvider.swift
//  FirebaseAuthProvider
//
//  Created by Lucia Cahojova on 08.12.2024.
//

public struct DefaultFirebaseAuthProvider {
    public init() {}
}

extension DefaultFirebaseAuthProvider: FirebaseAuthProvider {
    public func isUserLoggedIn() -> Bool {
        #warning("TODO: Add implementation")
        return false
    }
}
