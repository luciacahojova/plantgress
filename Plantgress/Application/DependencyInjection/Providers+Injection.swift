//
//  Providers+Injection.swift
//  Plantgress
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import FirebaseAuthProvider
import FirebaseFirestoreProvider
import FirebaseStorageProvider
import KeychainProvider
import Resolver

public extension Resolver {
    static func registerProviders() {
        
        register { DefaultFirebaseAuthProvider() as FirebaseAuthProvider }
        
        register { DefaultFirebaseFirestoreProvider() as FirebaseFirestoreProvider }
        
        register { DefaultFirebaseStorageProvider() as FirebaseStorageProvider }
        
        register { SystemKeychainProvider() as KeychainProvider }
        
    }
}
