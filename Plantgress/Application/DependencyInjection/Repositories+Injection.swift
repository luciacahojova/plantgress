//
//  Repositories+Injection.swift
//  Plantgress
//
//  Created by Lucia Cahojova on 03.12.2024.
//

import AuthToolkit
import Resolver
import SharedDomain

public extension Resolver {
    static func registerRepositories() {
        
        register { AuthRepositoryImpl(firebaseAuthProvider: resolve()) as AuthRepository }
        
    }
}
